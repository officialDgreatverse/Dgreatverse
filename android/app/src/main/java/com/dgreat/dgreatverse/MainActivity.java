package com.dgreat.dgreatverse;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Request mic permission up front so the WebView's getUserMedia()
        // calls (voice messages) have something to actually grant — without
        // this, Android never shows the permission dialog and every
        // getUserMedia({audio:true}) call silently fails in the APK.
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
                != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this,
                new String[]{Manifest.permission.RECORD_AUDIO}, 1001);
        }
    }
}