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

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

import ohos.ace.adapter.capability.bridge.BridgePlugin;

/**
 * Example ace activity class, which will load ArkUI-X ability instance.
 * StageActivity is provided by ArkUI-X
 *
 * @since 2025-10-20
 */
public class EntryNativeAbilityActivity extends Activity {
    private static final String TAG = "LOG";

    private static final String LOG_TAG = "[Native]:: ";

    private static final String JSON_TYPE = "JSON_TYPE";

    private static final String BINARY_TYPE = "BINARY_TYPE";

    private static final String MESSAGE_DATA = "Native Message Data";

    private TextView textViewForBridgeType;

    private TextView textViewForOperationLog;

    private BridgeUtil bridgeUtil;

    private void init() {
        bridgeUtil = BridgeManager.getInstance().get("BridgeBinaryObject", BridgePlugin.BridgeType.BINARY_TYPE);
        if (bridgeUtil != null) {
            bridgeUtil.setEntryNative1AbilityActivity(this);
        }
        bridgeUtil = BridgeManager.getInstance().get("BridgeJsonObject", BridgePlugin.BridgeType.JSON_TYPE);
        if (bridgeUtil != null) {
            bridgeUtil.setEntryNative1AbilityActivity(this);
        }
    }

    /**
     * Func nativeFunc
     *
     * @param data TextView组件更新文本内容
     */
    public void updateTextView(String data) {
        textViewForOperationLog.append(data);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.i(TAG, LOG_TAG + "EntryNativeAbilityActivity onCreate");
        super.onCreate(savedInstanceState);
        setContentView(R.layout.native_page);
        this.init();

        textViewForOperationLog = findViewById(R.id.tv_operation_log);
        textViewForOperationLog.setText("操作日志:\n");

        textViewForBridgeType = findViewById(R.id.tv_bridge_type);
        textViewForBridgeType.setText("BridgeType: " + JSON_TYPE);

        findViewById(R.id.btn_arkts).setOnClickListener(v -> {
            Intent intent = new Intent(EntryNativeAbilityActivity.this, EntryEntryAbilityActivity.class);
            startActivity(intent);
        });

        findViewById(R.id.btn_reset).setOnClickListener(v -> {
            textViewForOperationLog.setText("操作日志:\n");
        });

        findViewById(R.id.btn_switch_type).setOnClickListener(v -> {
            if (bridgeUtil.getBridgeType() == BridgePlugin.BridgeType.JSON_TYPE) {
                textViewForBridgeType.setText("BridgeType: " + BINARY_TYPE);
                bridgeUtil =
                        BridgeManager.getInstance().get("BridgeBinaryObject", BridgePlugin.BridgeType.BINARY_TYPE);
            } else {
                textViewForBridgeType.setText("BridgeType: " + JSON_TYPE);
                bridgeUtil =
                        BridgeManager.getInstance().get("BridgeJsonObject", BridgePlugin.BridgeType.JSON_TYPE);
            }
        });

        findViewById(R.id.btn_send_message).setOnClickListener(v -> {
            textViewForOperationLog.setText("操作日志\n");
            textViewForOperationLog.append("1.向ArkTS侧发送数据:\n\n【 (" + MESSAGE_DATA + ") 】\n\n");
            try {
                if (bridgeUtil == null) {
                    textViewForOperationLog.append("2.Bridge为空\n");
                    return;
                }
                bridgeUtil.sendMessage(MESSAGE_DATA);
            } catch (Exception e) {
                Log.e(TAG, LOG_TAG + "sendMessage failed, error is :", e);
            }
        });

        findViewById(R.id.btn_call_method).setOnClickListener(v -> {
            textViewForOperationLog.setText("操作日志\n");
            String arkFuncName = "ArkTSMethod";
            textViewForOperationLog.append("1.调用ArkTS侧方法:\n\n【 " + arkFuncName + " (" + MESSAGE_DATA + ") 】\n\n");
            try {
                if (bridgeUtil == null) {
                    return;
                }
                bridgeUtil.callMethod(arkFuncName, MESSAGE_DATA);
            } catch (Exception e) {
                Log.e(TAG, LOG_TAG + "callMethod failed, error is :", e);
            }
        });

        findViewById(R.id.btn_call_method_sync).setOnClickListener(v -> {
            textViewForOperationLog.setText("操作日志\n");
            String arkFuncName = "ArkTSMethodSync";
            textViewForOperationLog.append(
                    "1.同步方式调用ArkTS侧方法:\n\n【 " + arkFuncName + " (" + MESSAGE_DATA + ") 】\n\n");
            try {
                if (bridgeUtil == null) {
                    return;
                }
                Object data = bridgeUtil.callMethodSync(arkFuncName, MESSAGE_DATA);
                textViewForOperationLog.append("2.方法同步调用成功，返回值:\n\n【 " + data.toString() + " 】");
            } catch (Exception e) {
                Log.e(TAG, LOG_TAG + "callMethodSync failed");
            }
        });
    }

    @Override
    protected void onStop() {
        Log.i(TAG, LOG_TAG + "EntryNativeAbilityActivity onStop");
        super.onStop();
        finish();
    }

    @Override
    protected void onDestroy() {
        Log.i(TAG, LOG_TAG + "EntryNativeAbilityActivity onDestroy");
        super.onDestroy();
    }
}
