/*
 * Copyright (c) 2025-2025 Huawei Device Co., Ltd.
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

package com.example.project;

import android.Manifest;
import android.os.Bundle;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;


/**
 * Example ace activity class, which will load ArkUI-X ability instance.
 * StageActivity is provided by ArkUI-X
 *
 * @since 2025-01-03
 */
public class EntryEntryAbilityActivity extends BaseActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.e("HiHelloWorld", "EntryEntryAbilityActivity");
        setInstanceName("com.example.project:entry:EntryAbility:");
        super.onCreate(savedInstanceState);
        this.getFilesPermission();
    }

    private void getFilesPermission() {
        List<String> perList = new ArrayList<>();
        perList.add(Manifest.permission.READ_MEDIA_IMAGES);
        perList.add(Manifest.permission.READ_MEDIA_VIDEO);
        perList.add(Manifest.permission.READ_EXTERNAL_STORAGE);
        perList.add(Manifest.permission.WRITE_EXTERNAL_STORAGE);
        requestPermission(perList);
    }

    @Override
    public void throwPermissionResults(String permissionName, boolean isSuccess) {
        super.throwPermissionResults(permissionName, isSuccess);
        switch (permissionName) {
            case Manifest.permission.READ_EXTERNAL_STORAGE:
                Log.d("HiHelloWorld", "READ_EXTERNAL_STORAGE授权结果：" + isSuccess);
                break;
            case Manifest.permission.WRITE_EXTERNAL_STORAGE:
                Log.d("HiHelloWorld", "WRITE_EXTERNAL_STORAGE授权结果：" + isSuccess);
                break;
        }
    }
}
