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

import java.util.concurrent.ConcurrentHashMap;

import ohos.ace.adapter.capability.bridge.BridgePlugin;

/**
 * BridgeManager Bridge对象管理类，用于管理多个 Bridge 实例。
 * 每个 Bridge 实例通过一个唯一的 name（String）来标识。
 * 对外提供 get(String name) 方法，用于获取对应 name 的 Bridge 对象。
 *
 * @since 2025-10-20
 */
public class BridgeManager {
    private static final String TAG = "LOG";

    private static final String LOG_TAG = "[Native][BridgeManager]:: ";

    private static final BridgeManager INSTANCE = new BridgeManager();

    private final ConcurrentHashMap<String, BridgeUtil> bridgeMap;

    private BridgeManager() {
        bridgeMap = new ConcurrentHashMap<>();
    }

    /**
     * 获取 BridgeManager 单例对象
     *
     * @return BridgeManager单例对象
     */
    public static BridgeManager getInstance() {
        return INSTANCE;
    }

    /**
     * 根据 name 获取对应的 Bridge 实例
     * 如果该 name 对应的 Bridge 还不存在，则会创建一个新的 Bridge 并存入 Map
     * 如果现有 Bridge 不可用，会调用 unRegister 释放资源并从 Map 移除
     *
     * @param name       Bridge名称；既是Bridge对象的唯一标识，也是map中的key值
     * @param bridgeType Bridge的编码模式
     * @return 可用的 Bridge 对象，如果不可用或创建失败返回 null
     */
    public BridgeUtil get(String name, BridgePlugin.BridgeType bridgeType) {
        if (name == null || bridgeType == null) {
            Log.e(TAG, LOG_TAG + "Invalid argument");
            return null;
        }

        return bridgeMap.compute(name, (k, existingBridge) -> {
            if (existingBridge != null) {
                if (existingBridge.getBridgeType() == bridgeType) {
                    return existingBridge;
                } else {
                    Log.e(TAG, LOG_TAG + "Bridge bridgeType incompatible");
                    existingBridge.unRegister(name);
                    return null;
                }
            }

            return new BridgeUtil(name, bridgeType);
        });
    }
}