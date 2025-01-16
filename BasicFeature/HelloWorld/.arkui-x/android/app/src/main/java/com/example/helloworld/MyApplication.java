package com.example.helloworld;

import android.util.Log;

import ohos.stage.ability.adapter.StageApplication;

/**
 * Example ace application class, which will load ArkUI-X application instance.
 * StageApplication is provided by ArkUI-X
 *
 * @since 2025-01-15
 */
public class MyApplication extends StageApplication {
    private static final String LOG_TAG = "HiHelloWorld";

    private static final String RES_NAME = "res";

    @Override
    public void onCreate() {
        Log.e(LOG_TAG, "MyApplication");
        super.onCreate();
        Log.e(LOG_TAG, "MyApplication onCreate");
    }
}
