/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.example.hspui;

import android.app.Activity;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.util.Log;

import ohos.stage.ability.adapter.StageApplicationDelegate;

/**
 * Example ace activity class
 *
 * @since 2025-12-01
 */
public class NativeActivity extends Activity {
    private static final String TAG = "LOG";

    private static final String LOG_TAG = "[Test][JAVA][NativeActivity]:: ";

    private void showCaseRes(int id, boolean res) {
        GradientDrawable greenBg = new GradientDrawable();
        if (res) {
            greenBg.setColor(Color.GREEN);
        } else {
            greenBg.setColor(Color.RED);
        }
        findViewById(id).setBackground(greenBg);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.e(TAG, LOG_TAG + "onCreate");
        super.onCreate(savedInstanceState);
        setContentView(R.layout.native_page);

        findViewById(R.id.BTN_LoadHap).setOnClickListener(v -> {
            StageApplicationDelegate.loadModule("entry", "./ets/MyModuleLoader.ets");
        });

        findViewById(R.id.BTN_CallMethod).setOnClickListener(v -> {
            try {
                BridgeUtil object = BridgeUtil.getInstance();
                if (object == null) {
                    Log.e(TAG, LOG_TAG + "BridgeUtil object is null");
                    return;
                }
                Object data = object.callMethodSync("getDeviceInfo");
                Log.i(TAG, LOG_TAG + "DeviceInfo is " + data);
                this.showCaseRes(R.id.BTN_CallMethod, data.toString().contains(
                    "[ArkTS]: (Native) call getDeviceInfo by callMethodSync success"));
            } catch (Exception e) {
                Log.e(TAG, LOG_TAG + "callMethodSync failed, error is :", e);
                this.showCaseRes(R.id.BTN_CallMethod, false);
            }
        });
    }
}
