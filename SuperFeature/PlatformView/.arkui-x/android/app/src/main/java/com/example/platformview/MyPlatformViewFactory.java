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
    public IPlatformView getPlatformView(String id) {
        if ("MapView".equals(id)) {
            return new MyMapView(context, savedInstanceState);
        } else if ("VideoView".equals(id)) {
            return new MyVideoView(context);
        }
        return null;
    }

    @Override
    public IPlatformView getPlatformView(String id, String data) {
        if ("WebView".equals(id)) {
            return new MyWebView(context, data);
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
