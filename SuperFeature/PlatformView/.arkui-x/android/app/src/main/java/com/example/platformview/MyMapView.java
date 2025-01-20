package com.example.platformview;

import android.content.Context;
import android.os.Bundle;
import android.view.View;

import com.amap.api.maps.TextureMapView;

import ohos.ace.adapter.capability.platformview.IPlatformView;

/**
 * MyMapView.
 *
 * @since 2025-01-16
 */
public class MyMapView implements IPlatformView {
    TextureMapView mMapView;
    private String id = "MapView";

    MyMapView(Context context, Bundle savedInstanceState) {
        mMapView = new TextureMapView(context);
        mMapView.onCreate(savedInstanceState);
    }

    @Override
    public View getView() {
        return mMapView;
    }

    @Override
    public void onDispose() {
        mMapView.onDestroy();
    }

    @Override
    public String getPlatformViewID() {
        return id;
    }
}
