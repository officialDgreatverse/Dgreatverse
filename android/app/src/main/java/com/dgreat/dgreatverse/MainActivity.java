package com.dgreat.dgreatverse;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.webkit.PermissionRequest;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import com.getcapacitor.BridgeActivity;
import com.getcapacitor.BridgeWebChromeClient;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Native OS-level permission — controls whether the app can touch
        // the mic hardware at all.
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
                != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this,
                new String[]{Manifest.permission.RECORD_AUDIO}, 1001);
        }
    }

    @Override
    public void onStart() {
        super.onStart();
        // The OS permission above is separate from the WebView's OWN
        // permission gate for any getUserMedia() call made by the page's
        // JS — without this override, the WebView auto-denies that request
        // even after RECORD_AUDIO is granted natively, which is exactly why
        // "Microphone access denied" kept firing even with the system
        // permission set to Allow. Extending BridgeWebChromeClient (instead
        // of a bare WebChromeClient) keeps Capacitor's existing file-chooser
        // behavior for photo/file uploads intact — only permission requests
        // are handled differently here.
        this.bridge.getWebView().setWebChromeClient(new BridgeWebChromeClient(this.bridge) {
            @Override
            public void onPermissionRequest(final PermissionRequest request) {
                runOnUiThread(() -> request.grant(request.getResources()));
            }
        });
    }
}