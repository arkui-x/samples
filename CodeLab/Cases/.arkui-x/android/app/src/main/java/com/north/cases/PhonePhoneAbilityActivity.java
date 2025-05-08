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

package com.north.cases;

import android.Manifest;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import ohos.ace.adapter.capability.bridge.IMessageListener;
import ohos.stage.ability.adapter.StageActivity;

/**
 * 示例ACE活动类，用于加载ArkUI-X能力实例。
 *
 * @since 2025-01-07
 */
public class PhonePhoneAbilityActivity extends StageActivity implements IMessageListener {
    private static final int REQUEST_CODE_READ_EXTERNAL_STORAGE = 1010;

    private static final int REQUEST_CODE_READ_MEDIA_IMAGES = 1011;

    private static android.content.Context context;

    private BridgeUtil bridgeUtil = null;

    private void dynamicallyRequestPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_MEDIA_IMAGES) !=
                    PackageManager.PERMISSION_GRANTED ||
                ContextCompat.checkSelfPermission(this, Manifest.permission.READ_MEDIA_VIDEO) !=
                    PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(this, new String[]{
                    Manifest.permission.READ_MEDIA_VIDEO, Manifest.permission.READ_MEDIA_IMAGES},
                    REQUEST_CODE_READ_MEDIA_IMAGES);
            }
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (ContextCompat.checkSelfPermission(
                    this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(this,
                    new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, REQUEST_CODE_READ_EXTERNAL_STORAGE);
            }
        }
    }

    private void setStatusBarColor() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            getWindow().setStatusBarColor(Color.WHITE);
            setStatusBarTextColorBlack();
        }
    }

    private void setStatusBarTextColorBlack() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            getWindow().getDecorView().setSystemUiVisibility(
                getWindow().getDecorView().getSystemUiVisibility() | android.view.View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
        }
    }

    private void initBridgeObject() {
        context = this;
        this.bridgeUtil = new BridgeUtil(context, "BridgeUtil", getBridgeManager());
        this.bridgeUtil.setMessageListener(this);
    }

    private void startSms() {
        android.content.Intent smsIntent = new android.content.Intent(android.content.Intent.ACTION_SENDTO);
        smsIntent.setData(android.net.Uri.parse("smsto:103981630163222"));
        smsIntent.putExtra("sms_body", "2618");
        startActivity(smsIntent);
    }

    private void callbackTrigger(Object object) {
        if (object instanceof String && object.equals("ResetStatusBar")) {
            setStatusBarTextColorBlack();
        }
        if (object instanceof String && object.equals("startSms")) {
            startSms();
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setInstanceName("com.north.cases:phone:PhoneAbility:");
        super.onCreate(savedInstanceState);
        this.dynamicallyRequestPermissions();
        this.setStatusBarColor();
        this.initBridgeObject();
    }

    @Override
    public Object onMessage(Object object) {
        callbackTrigger(object);
        return "onMessage success return";
    }

    @Override
    public void onMessageResponse(Object object) {
    }
}
