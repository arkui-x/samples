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

import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.util.ArrayList;
import java.util.List;

import ohos.stage.ability.adapter.StageActivity;

/**
 * Example ace activity class, which will load ArkUI-X ability instance.
 * StageActivity is provided by ArkUI-X
 *
 * @since 2025-01-03
 */
public class BaseActivity extends StageActivity {
    private static final int REQUEST_CONDE = 0xFFFF;

    /**
     * 动态请求权限(入口)
     *
     * @param permissionNameList 需要授权的权限名称
     */
    public void requestPermission(List<String> permissionNameList) {
        List<String> UnauthorizedPermissionNameList = new ArrayList<>();
        for (String permission : permissionNameList) {
            int checkResult = ContextCompat.checkSelfPermission(this, permission);
            if (checkResult == PackageManager.PERMISSION_GRANTED) {
                throwPermissionResults(permission, true);
            } else if (checkResult == PackageManager.PERMISSION_DENIED) {
                UnauthorizedPermissionNameList.add(permission);
            } else {
                throwPermissionResults("Unknown_result", false);
            }
        }
        if (UnauthorizedPermissionNameList.size() == 0) {
            return;
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            String[] UnauthorizedPermissionNames = new String[UnauthorizedPermissionNameList.size()];
            for (int k = 0; k < UnauthorizedPermissionNameList.size(); k++) {
                UnauthorizedPermissionNames[k] = UnauthorizedPermissionNameList.get(k);
            }
            ActivityCompat.requestPermissions(this, UnauthorizedPermissionNames, REQUEST_CONDE);
        } else {
            throwPermissionResults("Below_VERSION_M", true);
        }
    }

    /**
     * 抛出授权结果（出口）
     *
     * @param permissionName 权限名称
     * @param isSuccess      该权限是否获得授权（true:获得授权  false:未获得授权）
     */
    public void throwPermissionResults(String permissionName, boolean isSuccess) {
        Log.e("HiHelloWorld", "throwPermissionResults");
    }


    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull
    int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode != REQUEST_CONDE) {
            return;
        }
        if (grantResults.length > 0) {
            for (int k = 0; k < permissions.length; k++) {
                if (grantResults[k] == PackageManager.PERMISSION_GRANTED) {
                    throwPermissionResults(permissions[k], true);
                }
                if (grantResults[k] == PackageManager.PERMISSION_DENIED) {
                    throwPermissionResults(permissions[k], false);
                }
            }
        } else {
            throwPermissionResults("Unknown_result", false);
        }
    }
}


