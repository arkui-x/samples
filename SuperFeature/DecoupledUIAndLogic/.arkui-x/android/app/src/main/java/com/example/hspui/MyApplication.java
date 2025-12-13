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

import android.app.Application;
import android.util.Log;

import ohos.stage.ability.adapter.StageApplicationDelegate;

/**
 * Example ace application class
 *
 * @since 2025-12-01
 */
public class MyApplication extends Application {
    private static final String TAG = "LOG";

    private static final String LOG_TAG = "[Test][JAVA][MyApplication]:: ";

    @Override
    public void onCreate() {
        Log.e(TAG, LOG_TAG + "onCreate");
        StageApplicationDelegate stageApplicationDelegate = new StageApplicationDelegate();
        stageApplicationDelegate.initApplication(this, false);
        super.onCreate();
    }
}
