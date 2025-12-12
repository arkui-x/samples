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

import android.util.Log;

import ohos.ace.adapter.capability.bridge.BridgePlugin;
import ohos.ace.adapter.capability.bridge.IMessageListener;
import ohos.ace.adapter.capability.bridge.IMethodResult;

/**
 * BridgeUtil
 *
 * @since 2025-12-01
 */
public class BridgeUtil extends BridgePlugin implements IMessageListener, IMethodResult {
    private static final String TAG = "LOG";

    private static final String LOG_TAG = "[Test][JAVA][BridgeUtil]:: ";

    private static final int LARGE_DATA_THRESHOLD = 1024;

    private static final BridgeUtil INSTANCE = new BridgeUtil("BridgeObject", BridgePlugin.BridgeType.JSON_TYPE);

    private BridgeUtil(String bridgeName, BridgeType bridgeType) {
        super(bridgeName, bridgeType);
        setMessageListener(this);
        setMethodResultListener(this);
    }

    /**
     * Get the BridgeUtil singleton object
     *
     * @return BridgeUtil singleton object
     */
    public static BridgeUtil getInstance() {
        return INSTANCE;
    }

    @Override
    public Object onMessage(Object data) {
        Log.i(TAG, LOG_TAG + "IMessageListener onMessage data: " + data);
        return "The message sent by the peer (ArkTS) via sendMessagehas been received";
    }

    @Override
    public void onMessageResponse(Object data) {
        Log.i(TAG, LOG_TAG + "IMessageListener onMessageResponse data: " + data);
    }

    @Override
    public void onSuccess(Object resultValue) {
        Log.i(TAG, LOG_TAG + "IMethodResult onSuccess called; data is " + "{ " + resultValue.toString() + " }");
    }

    @Override
    public void onError(String methodName, int errorCode, String errorMessage) {
        Log.i(TAG, LOG_TAG + "IMethodResult onError called; data is " + "{ methodName: " + methodName +
                "; errorCode" + ":" + " " + errorCode + "; " + "errorMessage: " + errorMessage + " }");
    }

    @Override
    public void onMethodCancel(String methodName) {
        Log.i(TAG, LOG_TAG + "IMethodResult onMethodCancel called; methodName is " + methodName);
    }
}
