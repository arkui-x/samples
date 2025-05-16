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

package com.example.enjoyarkuix.platformview;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.View;
import android.webkit.WebView;

import ohos.ace.adapter.capability.platformview.IPlatformView;

/**
 * MyWebView.
 *
 * @since 20
 */
public class MyWebView implements IPlatformView {
    private String id = "WebView";
    private WebView mWebView;

    @SuppressLint("SetJavaScriptEnabled")
    public MyWebView(Context context) {
        mWebView = new WebView(context);
        String url = "https://developer.huawei.com/";
        mWebView.getSettings().setJavaScriptEnabled(true);
        mWebView.getSettings().setDomStorageEnabled(true);
        mWebView.loadUrl(url);
    }

    @Override
    public View getView() {
        return mWebView;
    }

    @Override
    public void onDispose() {
        mWebView.destroy();
    }

    @Override
    public String getPlatformViewID() {
        return id;
    }
}
