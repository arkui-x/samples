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

package com.example.enjoyarkuix.activity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.maps.MapsInitializer;
import com.example.enjoyarkuix.bean.ItemDataBean;
import com.example.enjoyarkuix.platformbridge.Bridge;
import com.example.enjoyarkuix.platformview.MyPlatformViewFactory;
import ohos.ace.adapter.capability.bridge.BridgePlugin;
import ohos.ace.adapter.capability.bridge.TaskOption;
import ohos.stage.ability.adapter.StageActivity;

/**
 * Example ace activity class, which will load ArkUI-X ability instance.
 * StageActivity is provided by ArkUI-X
 *
 * @see <a href=
 *      "https://gitee.com/arkui-crossplatform/doc/blob/master/contribute/tutorial/how-to-build-Android-app.md">
 *      to build android library</a>
 * @since 20
 */
public class EntryEntryAbilityActivity extends StageActivity {
    private Bridge bridgeImpl = null;

    private Bridge bridgeCodec = null;

    private Bridge bridgeTask = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Intent intent = getIntent();
        if (intent == null) {
            Log.e("onCreate", "intent==null: ");
            return;
        }
        Object extra = intent.getSerializableExtra("ItemDataBean");
        if (extra instanceof ItemDataBean) {
            ItemDataBean itemDataBean = (ItemDataBean) extra;
            String modultName = itemDataBean.getItemModuleName();
            String abilityName = itemDataBean.getItemAbilityName();
            Log.i("onCreate", "=========: " + modultName + ":" + abilityName + ":");
            setInstanceName("com.example.enjoyarkuix:" + modultName + ":" + abilityName + ":");
            super.onCreate(savedInstanceState);
            platFormBridge();
            platFormView(savedInstanceState);
        } else {
            Log.e("YourTag", "The extra is not an instance of ItemDataBean");
        }
    }

    public void platFormBridge() {
        bridgeImpl = new Bridge(this, "Bridge", getBridgeManager());
        bridgeCodec = new Bridge(this, "BridgeCodec", getBridgeManager(), BridgePlugin.BridgeType.BINARY_TYPE);
        bridgeTask = new Bridge(this, "BridgeTask", getBridgeManager(), BridgePlugin.BridgeType.BINARY_TYPE,
                new TaskOption());
    }

    /**
     * Initializes and configures the platform view for the application.
     *
     * This method performs the following actions:
     * - Updates the privacy settings for AMapLocationClient and MapsInitializer.
     * - Creates and configures a custom platform view factory.
     * - Registers the platform view factory for use in the application.
     *
     * @param savedInstanceState The saved instance state bundle passed to the activity,
     *                           used to restore the state of the platform view.
     */
    public void platFormView(Bundle savedInstanceState) {
        AMapLocationClient.updatePrivacyShow(this, true, true);
        AMapLocationClient.updatePrivacyAgree(this, true);
        MapsInitializer.updatePrivacyShow(this, true, true);
        MapsInitializer.updatePrivacyAgree(this, true);
        MyPlatformViewFactory platformViewFactory = new MyPlatformViewFactory();
        platformViewFactory.setContext(this);
        platformViewFactory.setSavedInstanceState(savedInstanceState);
        registerPlatformViewFactory(platformViewFactory);
    }
}
