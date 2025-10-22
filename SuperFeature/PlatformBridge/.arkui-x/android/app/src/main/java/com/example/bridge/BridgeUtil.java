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

package com.example.bridge;

import android.util.Log;

import ohos.ace.adapter.capability.bridge.BridgePlugin;
import ohos.ace.adapter.capability.bridge.IMessageListener;
import ohos.ace.adapter.capability.bridge.IMethodResult;

/**
 * BridgeUtil 实例
 *
 * @since 2025-10-20
 */
public class BridgeUtil extends BridgePlugin implements IMessageListener, IMethodResult {
    private static final String TAG = "LOG";

    private static final String LOG_TAG = "[Native][BridgeUtil]:: ";

    private EntryNativeAbilityActivity entryNativeAbilityActivity = null;

    public BridgeUtil(String bridgeName, BridgeType bridgeType) {
        super(bridgeName, bridgeType);
        setMessageListener(this);
        setMethodResultListener(this);
    }

    public void setEntryNative1AbilityActivity(EntryNativeAbilityActivity activity) {
        entryNativeAbilityActivity = activity;
    }

    @Override
    public Object onMessage(Object data) {
        Log.i(TAG, LOG_TAG + "IMessageListener onMessage data: " + data.toString());
        return "这里是<Native>，成功接收到<ArkTS>数据";
    }

    @Override
    public void onMessageResponse(Object data) {
        Log.i(TAG, LOG_TAG + "IMessageListener onMessageResponse called; data is " + data.toString());
        this.entryNativeAbilityActivity.updateTextView(
                "2.数据发送成功，MessageResponse接收到返回消息:\n\n【 " + data.toString() + " 】");
    }

    @Override
    public void onSuccess(Object resultValue) {
        Log.i(TAG, LOG_TAG + "IMethodResult onSuccess called; data is " + "( " + resultValue.toString() + " )");
        this.entryNativeAbilityActivity.updateTextView(
                "2.方法调用成功，onSuccess接收到返回值:\n\n【 " + resultValue.toString() + " 】");
    }

    @Override
    public void onError(String methodName, int errorCode, String errorMessage) {
        Log.i(TAG, LOG_TAG +
                "IMethodResult onError called; data is " + "( methodName: " + methodName + "; errorCode:" +
                " " + errorCode + "; " + "errorMessage: " + errorMessage + " )");
    }

    @Override
    public void onMethodCancel(String methodName) {
        Log.i(TAG, LOG_TAG + "IMethodResult onMethodCancel called; methodName is " + methodName);
    }

    /**
     * Func nativeFunc
     *
     * @param param 函数测试参数
     * @return 函数测试返回值
     */
    public String nativeFunc(String param) {
        return "Native方法 <NativeFunc()> 被调用成功。参数为：" + param;
    }

    /**
     * Func nativeFuncWithCallback
     *
     * @param param 函数测试参数
     * @return 函数测试返回值
     */
    public String nativeFuncWithCallback(String param) {
        callMethod("nativeFuncWithCallback");
        return "Native方法 <NativeFuncWithCallback()> 被调用成功。参数为：" + param;
    }

    /**
     * Func nativeFuncSync
     *
     * @param param 函数测试参数
     * @return 函数测试返回值
     */
    public String nativeFuncSync(String param) {
        return "Native方法 <NativeFuncSync()> 被调用成功。参数为：" + param;
    }
}
