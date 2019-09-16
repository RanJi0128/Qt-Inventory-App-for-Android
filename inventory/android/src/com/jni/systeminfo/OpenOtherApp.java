
package com.jni.systeminfo;

import android.content.IntentFilter;
import android.content.Intent;

import android.content.pm.PackageManager;
import android.content.Context;
import android.provider.Settings;

public class OpenOtherApp {

    public static void openApp(Context context) {

                Context ctx=context; // or you can replace **'this'** with your **ActivityName.this**
                try {
                     // Intent i = ctx.getPackageManager().getLaunchIntentForPackage("com.lonelycatgames.Xplore");
                      Intent i = new Intent(android.provider.Settings.ACTION_NETWORK_OPERATOR_SETTINGS);
                      ctx.startActivity(i);
                } catch (Exception e) {

                }

        }

}
