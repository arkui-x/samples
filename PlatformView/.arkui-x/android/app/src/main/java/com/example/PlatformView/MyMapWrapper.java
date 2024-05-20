package com.example.PlatformView;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import com.amap.api.maps.AMap;
import com.amap.api.maps.TextureMapView;
import com.amap.api.maps.UiSettings;
import ohos.ace.adapter.capability.platformview.IPlatformView;

public class MyMapWrapper implements IPlatformView {
    public TextureMapView mMapView = null;
    private Context mContext;
    private String id = "PlatformViewTest1";

    MyMapWrapper(Context context, Bundle savedInstanceState) {
        this.mContext = context;
        mMapView = new TextureMapView(context);
        mMapView.onCreate(savedInstanceState);
        AMap aMap = mMapView.getMap();
        UiSettings uiSettings = aMap.getUiSettings();
        uiSettings.setZoomControlsEnabled(false);
    }

    @Override
    public View getView() {
        return mMapView;
    }

    @Override
    public  void onDispose() {
        mMapView.onDestroy();
    }

    @Override
    public String getXComponentID() {
        return id;
    }
}
