package com.example.platformview;

import android.content.Context;
import android.os.Bundle;

import ohos.ace.adapter.capability.platformview.IPlatformView;
import ohos.ace.adapter.capability.platformview.PlatformViewFactory;

/**
 * MyPlatformViewFactory.
 *
 * @since 2025-01-16
 */
public class MyPlatformViewFactory extends PlatformViewFactory {
    private Context context;
    private Bundle savedInstanceState;

    @Override
    public IPlatformView getPlatformView(String Id) {
        if ("MapView".equals(Id)) {
            return new MyMapView(context, savedInstanceState);
        } else if ("WebView".equals(Id)) {
            return new MyWebView(context);
        } else if ("VideoView".equals(Id)) {
            return new MyVideoView(context);
        }
        return null;
    }

    public void setContext(Context context) {
        this.context = context;
    }

    public void setSavedInstanceState(Bundle savedInstanceState) {
        this.savedInstanceState = savedInstanceState;
    }
}
