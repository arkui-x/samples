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

package com.example.enjoyarkuix.platformbridge;

import android.content.Context;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

import ohos.ace.adapter.capability.bridge.BridgeManager;
import ohos.ace.adapter.capability.bridge.BridgePlugin;
import ohos.ace.adapter.capability.bridge.IMessageListener;
import ohos.ace.adapter.capability.bridge.IMethodResult;
import ohos.ace.adapter.capability.bridge.MethodData;
import ohos.ace.adapter.capability.bridge.TaskOption;

/**
 * Platform-side Bridge object, calling native methods.
 *
 * @since 2025-01-15
 */
public class Bridge extends BridgePlugin implements IMessageListener, IMethodResult {
    private static final String LOG_TAG = "[BridgeNative]";

    private String name;

    private Context context;

    /**
     * Func: constructor
     *
     * @param context       Context of the current Activity
     * @param name          Platform bridge name
     * @param bridgeManager BridgePlugin object manager
     * @since 2025-01-07
     */
    public Bridge(Context context, String name, BridgeManager bridgeManager) {
        super(context, name, bridgeManager);
        this.name = name;
        this.context = context;
        setMethodResultListener(this);
        setMessageListener(this);
    }

    /**
     * Func: constructor
     *
     * @param context       Context of the current Activity
     * @param name          Platform bridge name
     * @param bridgeManager BridgePlugin object manager
     * @param codecType     Bridge Type
     * @since 2025-01-07
     */
    public Bridge(Context context, String name, BridgeManager bridgeManager, BridgeType codecType) {
        super(context, name, bridgeManager, codecType);
        this.name = name;
        this.context = context;
        setMethodResultListener(this);
        setMessageListener(this);
    }

    /**
     * Func: constructor
     *
     * @param context       Context of the current Activity
     * @param name          Platform bridge name
     * @param bridgeManager BridgePlugin object manager
     * @param codecType     Bridge Type
     * @param taskOption    Task Option
     * @since 2025-01-07
     */
    public Bridge(
            Context context, String name, BridgeManager bridgeManager, BridgeType codecType, TaskOption taskOption) {
        super(context, name, bridgeManager, codecType, taskOption);
        this.name = name;
        this.context = context;
        setMethodResultListener(this);
        setMessageListener(this);
    }

    /**
     * Func: getHelloArkUI
     *
     * @param stringParam Func params
     * @return Data
     * @since 2025-01-07
     */
    public String getHelloArkUI(String stringParam) {
        Log.i(LOG_TAG, "Android Bridge getHelloArkUI stringParam is " + stringParam);
        return "Hello ArkUI! " + stringParam;
    }

    /**
     * Func: methodOfPlatform
     *
     * @param stringParam Func params
     * @return Data
     * @since 2025-01-07
     */
    public String methodOfPlatform(String stringParam) {
        Log.i(LOG_TAG, "Android Bridge methodOfPlatform stringParam is " + stringParam);
        List<Object> paramObject = new ArrayList<>();
        paramObject.add(stringParam);
        Object[] paramArray = paramObject.toArray();
        MethodData methodData = new MethodData("methodOfPlatform", paramArray);
        callMethod(methodData);
        return "Method of Platform call successful." + stringParam;
    }

    @Override
    public Object onMessage(Object object) {
        Log.i(LOG_TAG, "onMessage data: " + object.toString());
        return "PlatformBridge Successfully receives the TsMessage. " + object.toString();
    }

    @Override
    public void onMessageResponse(Object object) {
        Log.i(LOG_TAG, "onMessageResponse data: " + object.toString());
    }

    @Override
    public void onSuccess(Object object) {
        if (object == null) {
            Log.i(LOG_TAG, "bridge return data is null");
            sendMessage("PlatformBridge successfully calls method of TS, The method is of type void");
        } else {
            Log.i("bridge onSuccess data: ", object.toString());
            String result =
                    "PlatformBridge successfully calls method of TS, and the return value is " + object.toString();
            sendMessage(result);
        }
    }

    @Override
    public void onError(String methodName, int errorCode, String errorMessage) {
        Log.e(LOG_TAG, "onError: " + methodName + " " + String.valueOf(errorCode) + errorMessage);
    }

    @Override
    public void onMethodCancel(String methodName) {
        Log.i(LOG_TAG, "onMethodCancel");
    }
}