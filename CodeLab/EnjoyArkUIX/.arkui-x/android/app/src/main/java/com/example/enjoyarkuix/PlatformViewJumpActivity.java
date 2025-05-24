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

package com.example.enjoyarkuix;

import android.os.Bundle;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

/**
 * PlatformViewJumpActivity
 *
 * @since 20
 */
public class PlatformViewJumpActivity extends AppCompatActivity {
    private WebView webview;

    /**
     * Called when the activity is starting. This is where most initialization should go:
     * - Set the content view to the appropriate layout resource.
     * - Find and initialize views.
     * - Configure web settings for the WebView.
     * - Load a URL in the WebView.
     *
     * @param savedInstanceState If the activity is being re-initialized after previously being shut down then this
     *  Bundle contains the data it most recently supplied in onSaveInstanceState(Bundle).
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.platform_view);
        TextView textView = findViewById(R.id.content);
        textView.setText("原生区域");
        webview = findViewById(R.id.webview);
        WebSettings webSettings = webview.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setDefaultTextEncodingName("utf-8");
        webSettings.setSupportZoom(false);
        webSettings.setBuiltInZoomControls(false);
        webview.loadUrl("https://developer.huawei.com/");
    }
}