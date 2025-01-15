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
import android.util.Log;
import android.view.View;
import android.view.Window;

import androidx.appcompat.app.AppCompatDelegate;

import com.huawei.hmos.world.ArkuixEntryAbilityActivity;

import ohos.ace.adapter.capability.bridge.BridgeManager;
import ohos.ace.adapter.capability.bridge.BridgePlugin;

/**
 * Platform-side Bridge object, calling native methods.
 *
 * @since 2025-01-07
 */
public class BridgeWindowUtil extends BridgePlugin {
    private final String TAG = "[BridgeWindowUtil]";

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
    public BridgeWindowUtil(Context context, String name, BridgeManager bridgeManager) {
        super(context, name, bridgeManager);
        this.name = name;
        this.context = context;
    }

    /**
     * Func: Application update Status Bar Color
     *
     * @param isDark     if is dark, value is true.
     * @since 2025-01-07
     */
    public void updateStatusBarColor(Boolean isDark) {
        try {
            if (this.context instanceof ArkuixEntryAbilityActivity) {
                ArkuixEntryAbilityActivity activityContext = (ArkuixEntryAbilityActivity) this.context;
                Window window = activityContext.getWindow();
                View view = window.getDecorView();
                int vis = view.getSystemUiVisibility();
                int currentNightMode = AppCompatDelegate.getDefaultNightMode();
                if (currentNightMode == AppCompatDelegate.MODE_NIGHT_YES) {
                    vis |= View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
                } else if (currentNightMode == AppCompatDelegate.MODE_NIGHT_NO) {
                    vis &= ~View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
                }
                view.setSystemUiVisibility(vis);
                Log.i(TAG, "Succeeded in setting the system bar properties.");
            }
        } catch (Exception exception) {
            Log.e(TAG, "Failed to set the system bar properties. Cause: " + exception.toString());
        }
    }
}