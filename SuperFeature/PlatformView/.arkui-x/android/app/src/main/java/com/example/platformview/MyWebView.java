package com.example.platformview;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.View;
import android.webkit.WebView;

import ohos.ace.adapter.capability.platformview.IPlatformView;

/**
 * MyWebView.
 *
 * @since 2025-01-16
 */
public class MyWebView implements IPlatformView {
    private String id = "WebView";
    private WebView mWebView;

    @SuppressLint("SetJavaScriptEnabled")
    MyWebView(Context context) {
        mWebView = new WebView(context);
        String url = "https://gitcode.com/arkui-x";
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
