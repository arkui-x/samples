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

package com.example.splitscreenview;

import android.os.Bundle;
import android.util.Log;

import ohos.stage.ability.adapter.StageActivity;

/**
 * 示例ACE活动类，用于加载ArkUI-X能力实例。
 *
 * @since 2025-08-15
 */
public class EntryMain2AbilityActivity extends StageActivity {
    private static final String LOG_TAG = "[Java]";

    private static final String CLASS_NAME = "[EntryMain2AbilityActivity] ";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.i(LOG_TAG, LOG_TAG + CLASS_NAME + "onCreate");
        setInstanceName("com.example.splitscreenview:entry:Main2Ability:");
        super.onCreate(savedInstanceState);
    }

    @Override
    public void onDestroy() {
        Log.i(LOG_TAG, LOG_TAG + CLASS_NAME + "onDestroy");
        super.onDestroy();
    }
}
