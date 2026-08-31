// scripts/obfuscate.js
//
// Obfuscates the inline <script> blocks inside www/index.html right before
// Capacitor packages www/ into the Android build. This only rewrites the
// file in the CI runner's working copy — nothing is committed back, so your
// real source in the repo stays readable.
//
// IMPORTANT: renameGlobals stays false. DgreatVerse wires up buttons with
// inline handlers like onclick="insertEmoji(...)" and onclick="pickReaction(...)"
// living in the HTML markup itself. If top-level function/const names got
// renamed, those onclick="" strings would go on calling the old names and
// every button would silently stop working. Local variables inside
// functions still get fully mangled/hex-renamed — only the global,
// HTML-referenced surface is left alone.
const fs = require('fs');
const path = require('path');
const JavaScriptObfuscator = require('javascript-obfuscator');

const filePath = path.join(__dirname, '..', 'www', 'index.html');
let html = fs.readFileSync(filePath, 'utf8');

const scriptTagRe = /<script((?:\s+[^>]*)?)>([\s\S]*?)<\/script>/gi;
let count = 0;

html = html.replace(scriptTagRe, (match, attrs, code) => {
  // Skip external scripts (src="...") and non-JS scripts (e.g. ld+json)
  if (/\bsrc\s*=/i.test(attrs)) return match;
  if (/type\s*=\s*["']?application\/ld\+json["']?/i.test(attrs)) return match;
  if (!code.trim()) return match;

  const result = JavaScriptObfuscator.obfuscate(code, {
    compact: true,
    controlFlowFlattening: false,   // heavy transform, not worth it on a ~600KB file
    deadCodeInjection: false,       // same — keeps CI build time and APK size sane
    stringArray: true,
    stringArrayEncoding: ['base64'],
    stringArrayThreshold: 0.75,
    identifierNamesGenerator: 'hexadecimal',
    renameGlobals: false,           // see note above — do not flip this on
    selfDefending: false,           // can misbehave inside Android WebViews
    disableConsoleOutput: false,
  }).getObfuscatedCode();

  count++;
  return `<script${attrs}>${result}</script>`;
});

if (count === 0) {
  console.error('No inline <script> blocks were obfuscated — check www/index.html path/structure.');
  process.exit(1);
}

fs.writeFileSync(filePath, html, 'utf8');
console.log(`Obfuscated ${count} inline <script> block(s) in www/index.html`);