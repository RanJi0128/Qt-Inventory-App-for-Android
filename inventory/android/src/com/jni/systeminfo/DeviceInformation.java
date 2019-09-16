package com.jni.systeminfo;

import android.content.pm.PackageManager;
import android.os.Build;
import android.content.Context;



public class DeviceInformation
{
    public static native void SystemInformation(String body);
    public static void sendInformation(Context context) {

        String body = null;
        try {
                    body = context.getPackageManager().getPackageInfo(context.getPackageName(), 0).versionName;
                    body = "Device OS: Android \nDevice OS version: " +
                            Build.VERSION.RELEASE + "\nApp Version: " + body + "\nDevice Brand: " + Build.BRAND +
                            "\nDevice Model: " + Build.MODEL + "\nDevice Manufacturer: " + Build.MANUFACTURER;

                            SystemInformation(body);

                } catch (PackageManager.NameNotFoundException e) {
            }



    }

}
