// sw.js — new push notification service worker

self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', (event) => event.waitUntil(clients.claim()));

self.addEventListener('push', (event) => {
  let data = {};
  try { data = event.data ? event.data.json() : {}; } catch (e) { /* ignore bad payload */ }

  const title = data.title || 'New notification';
  const options = {
    body: data.body || '',
    icon: '/Dgreatverse/icon-192.png',
    badge: '/Dgreatverse/icon-192.png',
    data: { url: data.url || '/Dgreatverse/' },
    vibrate: [200, 100, 200]
  };

  event.waitUntil(self.registration.showNotification(title, options));
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const url = (event.notification.data && event.notification.data.url) || '/Dgreatverse/';

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      // Match on pathname only (ignore ?chat=/?group= query string), since
      // the app is a single index.html page — an already-open tab should be
      // focused and told which chat to open, rather than always spawning a
      // new window just because the query string differs per notification.
      const targetPath = new URL(url, self.location.origin).pathname;
      for (const client of clientList) {
        const clientPath = new URL(client.url, self.location.origin).pathname;
        if (clientPath === targetPath && 'focus' in client) {
          client.postMessage({ type: 'dg-deep-link', url });
          return client.focus();
        }
      }
      if (clients.openWindow) return clients.openWindow(url);
    })
  );
});
