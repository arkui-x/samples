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

import android.content.Context;
import android.content.Intent;
import android.content.res.AssetManager;
import android.content.res.Configuration;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.example.enjoyarkuix.R;
import com.example.enjoyarkuix.stagedynamic.DynamicHapAbility;
import com.example.enjoyarkuix.stagedynamic.DynamicHapOneActivity;
import com.example.enjoyarkuix.stagedynamic.DynamicHapTwoActivity;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * DynamizationJumpActivity
 *
 * @since 20
 */

public class DynamizationJumpActivity extends AppCompatActivity {
    private static final String ASSETS_SUB_PATH = "arkui-x";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.one_activity);
        initTopBar();
        initButtons();
    }
    private void initTopBar() {
        View ivTopBarBackView = findViewById(R.id.ivTopBarBack);
        if (ivTopBarBackView instanceof ImageView) {
            ImageView ivTopBarBack = (ImageView) ivTopBarBackView;
            ivTopBarBack.setOnClickListener(view -> finish());
        } else {
            Log.e("TopBarInit", "ivTopBarBack is not an instance of ImageView");
        }
        View view = findViewById(R.id.tvTopBarTitle);
        if (view instanceof TextView) {
            TextView title = (TextView) view;
            title.setText("动态化加载Hap");
        } else {
            Log.e("Tag", "The view is not an instance of TextView");
        }
    }
    private void initButtons() {
        setupButton(R.id.mButton01, v -> startActivity(new Intent(this, DynamicHapAbility.class)));
        setupButton(R.id.mButton02, v -> startActivity(new Intent(this, DynamicHapOneActivity.class)));
        setupButton(R.id.mButton03, v -> startActivity(new Intent(this, DynamicHapTwoActivity.class)));
        setupButton(R.id.mButton04, v -> copyFilesFromAssetsDoc(this, "doc", getApplication().getFilesDir().getPath()));
        setupButton(R.id.mButton05, v ->
        copyFilesFromAssetsDoc(this, "resh", getApplication().getFilesDir().getPath()));
        setupButton(R.id.mButton07, v -> {
            deleteDirectoryContents(getApplication().getFilesDir().getPath() + "/arkui-x/dynamicHap");
            deleteDirectoryContents(getApplication().getFilesDir().getPath() + "/arkui-x/dynamicHapOne");
            deleteDirectoryContents(getApplication().getFilesDir().getPath() + "/arkui-x/dynamicHapTwo");
        });
        setupButton(R.id.mButton08, v -> copyAllResource());
    }
    private void setupButton(int buttonId, View.OnClickListener listener) {
        Button button = findViewById(buttonId);
        if (button != null) {
            button.setOnClickListener(listener);
        } else {
            Log.e("ButtonInit", "Button with ID " + buttonId + " not found");
        }
    }

    /**
     * Copies files or directories from the assets folder to a specified sandbox path.
     *
     * @param context       The context used to access the assets.
     * @param assetsDocPath The path within the assets folder to copy from. This can be a file or directory.
     * @param sandBoxPath   The destination path in the sandbox where the assets will be copied.
     *
     * The method recursively copies directories and their contents. If the source is a file, it copies the file
     * to the destination. It also ensures that the copied files and directories have appropriate permissions
     * (readable, writable, and executable).
     *
     * If the destination file ends with ".so", it explicitly sets the file to be writable, readable, and executable.
     *
     * Logs errors and debug information using the Android Log class.
     *
     * Exceptions:
     * - IOException: If an error occurs while accessing or copying files.
     */
    public void copyFilesFromAssetsDoc(Context context, String assetsDocPath, String sandBoxPath) {
        try {
            String[] fileNames = context.getAssets().list(assetsDocPath);
            if (fileNames.length > 0) {
                File file = new File(sandBoxPath);
                if (!file.exists()) {
                    file.mkdirs();
                    file.setWritable(true, false);
                    file.setReadable(true, false);
                    file.setExecutable(true, false);
                }
                for (String fileName : fileNames) {
                    copyFilesFromAssetsDoc(context, assetsDocPath + "/" + fileName,
                            sandBoxPath + "/" + fileName);
                }
            } else {
                Log.d("DynamicLoads", "fileNames: " + assetsDocPath);
                File targetFile = new File(sandBoxPath);
                try (InputStream sourceFileInput = context.getAssets().open(assetsDocPath);
                     FileOutputStream targetFileOutPut = new FileOutputStream(targetFile)) {
                    byte[] buffer = new byte[2048];
                    int byteCount;
                    while ((byteCount = sourceFileInput.read(buffer)) != -1) {
                        targetFileOutPut.write(buffer, 0, byteCount);
                    }
                    targetFileOutPut.flush();
                } catch (IOException e) {
                    Log.e("YourTag", "Error message", e);
                }
                if (sandBoxPath.endsWith(".so")) {
                    targetFile.setWritable(true, false);
                    targetFile.setReadable(true, false);
                    targetFile.setExecutable(true, false);
                }
            }
        } catch (IOException e) {
            Log.e("YourTag", "Error message", e);
        }
    }

    private boolean deleteDirectoryContents(String dirPath) {
        File dir = new File(dirPath);
        if (!dir.isDirectory()) {
            Log.e("DynamicLoads", "Invalid directory path: " + dirPath);
            return false;
        }

        File[] files = dir.listFiles();
        if (files == null) {
            Log.e("DynamicLoads", "Failed to list files in directory: " + dirPath);
            return false;
        }

        for (File file : files) {
            String filePath;
            try {
                filePath = file.getCanonicalPath();
            } catch (IOException e) {
                Log.e("DynamicLoads", "Failed to get canonical path for file: ", e);
                return false;
            }

            if (file.isDirectory()) {
                if (!deleteDirectoryContents(filePath)) {
                    return false;
                }
            }

            if (!file.delete()) {
                Log.e("DynamicLoads",
                        "Failed to delete " + (file.isDirectory() ? "directory" : "file") + ": " + filePath);
                return false;
            }
        }
        return true;
    }

    private void copyAllResource() {
        AssetManager assets = DynamizationJumpActivity.this.getAssets();
        String moduleResourcesDirectory = "";
        String moduleResourcesIndex = "";
        List<String> moduleResources = new ArrayList<>();
        try {
            String[] list = assets.list(ASSETS_SUB_PATH);
            for (String name : list) {
                if ("systemres".equals(name)) {
                    moduleResources.add(name);
                } else {
                    moduleResourcesDirectory = name + "/" + "resources";
                    moduleResourcesIndex = name + "/" + "resources.index";
                    moduleResources.add(moduleResourcesDirectory);
                    moduleResources.add(moduleResourcesIndex);
                }
            }
        } catch (IOException e) {
            Log.e("DynamicLoads", "read resources err: " + e.getMessage());
        }
        for (String resourcesName : moduleResources) {
            copyFilesFromAssets(ASSETS_SUB_PATH + "/" + resourcesName,
                    DynamizationJumpActivity.this.getApplicationContext().getFilesDir().getPath() +
                            "/" + ASSETS_SUB_PATH + "/" + resourcesName);
        }
    }

    private void copyFilesFromAssets(String assetsPath, String savePath) {
        InputStream is = null;
        FileOutputStream fos = null;
        try {
            String[] fileNames = DynamizationJumpActivity.this.getAssets().list(assetsPath);
            File file = new File(savePath);
            if (fileNames.length > 0) {
                if (!file.exists()) {
                    file.mkdirs();
                }
                for (String fileName : fileNames) {
                    copyFilesFromAssets(assetsPath + "/" + fileName, savePath + "/" + fileName);
                }
            } else {
                is = DynamizationJumpActivity.this.getAssets().open(assetsPath);
                fos = new FileOutputStream(file);
                byte[] buffer = new byte[1024];
                int byteCount = 0;
                while ((byteCount = is.read(buffer)) != -1) {
                    fos.write(buffer, 0, byteCount);
                }
                fos.flush();
            }
        } catch (IOException e) {
            Log.e("DynamicLoads", "read or write data err: " + e.getMessage());
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    Log.e("DynamicLoads", "InputStream close err: " + e.getMessage());
                }
            }
            if (fos != null) {
                try {
                    fos.close();
                } catch (IOException e) {
                    Log.e("DynamicLoads", "FileOutputStream close err: " + e.getMessage());
                }
            }
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    /**
     * Called by the system when the device configuration changes while your activity is running.
     * This method allows you to handle configuration changes such as screen orientation,
     * keyboard availability, or language changes without restarting the activity.
     *
     * @param newConfig The new device configuration.
     */
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
    }
}