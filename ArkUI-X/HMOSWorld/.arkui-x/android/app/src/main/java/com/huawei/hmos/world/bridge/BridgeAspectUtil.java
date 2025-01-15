/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

package com.huawei.hmos.world.bridge;

import android.content.Context;
import android.content.pm.PackageManager;
import android.util.Log;

import com.huawei.hmos.world.ArkuixEntryAbilityActivity;

import ohos.ace.adapter.capability.bridge.BridgeManager;
import ohos.ace.adapter.capability.bridge.BridgePlugin;

/**
 * Platform-side Bridge object, calling native methods.
 *
 * @since 2025-01-07
 */
public class BridgeAspectUtil extends BridgePlugin {
    private final String TAG = "[BridgeAspectUtil]";

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
    public BridgeAspectUtil(Context context, String name, BridgeManager bridgeManager) {
        super(context, name, bridgeManager);
        this.name = name;
        this.context = context;
    }

    /**
     * Func: Application get version name
     *
     * @return Version name
     * @throws NameNotFoundException    throw error
     * @since 2025-01-07
     */
    public String getVersionName() throws PackageManager.NameNotFoundException {
        PackageManager pm = context.getPackageManager();
        String packageName = context.getPackageName();
        return pm.getPackageInfo(packageName, 0).versionName;
    }

    /**
     * Func: Application exit
     *
     * @since 2025-01-07
     */
    public void exit() {
        Log.w(TAG, "Warning app will force quit.");
        System.exit(0);
    }

    /**
     * Func: Application switching to run in the background
     *
     * @since 2025-01-07
     */
    public void goToBackground() {
        Log.w(TAG, "Warning app will Cut to background running.");
        if (this.context instanceof ArkuixEntryAbilityActivity) {
            ArkuixEntryAbilityActivity activityContext = (ArkuixEntryAbilityActivity) this.context;
            activityContext.moveTaskToBack(false);
        }
    }
}