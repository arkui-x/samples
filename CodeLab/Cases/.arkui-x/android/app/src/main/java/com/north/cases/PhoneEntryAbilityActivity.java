/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
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

import android.os.Bundle;

import ohos.stage.ability.adapter.StageActivity;

/**
 * 示例ACE活动类，用于加载ArkUI-X能力实例。
 *
 * @since 2026-04-14
 */
public class PhoneEntryAbilityActivity extends StageActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setInstanceName("com.north.cases:phone:EntryAbility:");
        super.onCreate(savedInstanceState);
    }
}
