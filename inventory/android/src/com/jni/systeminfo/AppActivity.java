
package com.jni.systeminfo;


import android.app.Activity;
import android.os.Bundle;

import android.os.Handler;
import android.util.Log;
import android.os.Message;

import java.util.Timer;

//import android.content.IntentFilter;
//import android.content.Intent;

public class AppActivity extends org.qtproject.qt5.android.bindings.QtActivity
{


    public static long DISCONNECT_TIMEOUT = 300000;// x min = x * 60 * 1000 ms

    public AppActivity()
    {
        BatteryLevelListener.Init(this);

        //Log.i("Main", Integer.toString(logtim));
    }
    public static void sysLogoffTime(int time) {

        if(time>0)
          DISCONNECT_TIMEOUT = time * 60 * 1000;
        else
          DISCONNECT_TIMEOUT = 1440 * 60 * 1000;
       // Log.i("Main", Long.toString(DISCONNECT_TIMEOUT));
    }

    private Handler disconnectHandler = new Handler(){
        public void handleMessage(Message msg) {
        }
    };

    private Runnable disconnectCallback = new Runnable() {
        @Override
        public void run() {
           // Perform any required operation on disconnect
             System.exit(0);
           // Logout from app
        }
    };

    public void resetDisconnectTimer(){
        disconnectHandler.removeCallbacks(disconnectCallback);
        disconnectHandler.postDelayed(disconnectCallback, DISCONNECT_TIMEOUT);
    }

    public void stopDisconnectTimer(){
        disconnectHandler.removeCallbacks(disconnectCallback);
    }

    @Override
    public void onUserInteraction(){
        resetDisconnectTimer();
    }

    @Override
    public void onResume() {
        super.onResume();
        resetDisconnectTimer();
    }

    @Override
    public void onStop() {
        super.onStop();
        stopDisconnectTimer();
    }
//    public void openNetworkSetting()
//    {
//       startActivityForResult(new Intent(android.provider.Settings.ACTION_NETWORK_OPERATOR_SETTINGS), 0);
//    }

}

