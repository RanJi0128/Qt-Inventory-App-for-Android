package com.jni.systeminfo;

import android.app.Activity;
import android.Manifest;
import android.content.BroadcastReceiver;
import android.content.IntentFilter;
import android.content.Intent;
import android.os.BatteryManager;
import android.content.Context;
import android.os.CountDownTimer;

import java.util.ArrayList;
import java.util.List;

import com.karumi.dexter.Dexter;
import com.karumi.dexter.MultiplePermissionsReport;
import com.karumi.dexter.PermissionToken;
import com.karumi.dexter.listener.PermissionRequest;
import com.karumi.dexter.listener.multi.MultiplePermissionsListener;


public class BatteryLevelListener
{
    private static Activity m_ActivityInstance;

    public static void Init(Activity ActivityInstance)
    {
        m_ActivityInstance = ActivityInstance;

    }

    public static native void BatteryStateChanged(int Level, boolean OnCharge);


    public static void InstallBatteryListener()
    {
        IntentFilter BatteryLevelFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);

        BroadcastReceiver BatteryLevelReceiver = new BroadcastReceiver()
        {
            public void onReceive(Context context, Intent intent)
            {
                boolean OnCharge = (intent.getIntExtra(BatteryManager.EXTRA_PLUGGED, -1) == 0) ? false : true;
                int Level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1);
                int Scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);

                if(Level >= 0 && Scale > 0)
                {
                    BatteryStateChanged((Level * 100) / Scale, OnCharge);
                }
            }
        };

        m_ActivityInstance.registerReceiver(BatteryLevelReceiver, BatteryLevelFilter);
        Dexter.withActivity(m_ActivityInstance)
                        .withPermissions(
                                Manifest.permission.READ_EXTERNAL_STORAGE,
                                Manifest.permission.WRITE_EXTERNAL_STORAGE,
                                Manifest.permission.INTERNET,
                                Manifest.permission.ACCESS_WIFI_STATE,
                                Manifest.permission.ACCESS_NETWORK_STATE,
                                Manifest.permission.ACCESS_FINE_LOCATION,
                                Manifest.permission.ACCESS_COARSE_LOCATION
                        ).withListener(new MultiplePermissionsListener() {
                    @Override public void onPermissionsChecked(MultiplePermissionsReport report) {
                    }
                    @Override public void onPermissionRationaleShouldBeShown(List<PermissionRequest> permissions, PermissionToken token) {}
                }).check();



    }
}
