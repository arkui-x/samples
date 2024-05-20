package com.example.PlatformView;

import android.content.Context;
import android.os.Bundle;
import ohos.ace.adapter.capability.platformview.IPlatformView;
import ohos.ace.adapter.capability.platformview.PlatformViewFactory;

public class MyPlatformViewFactory extends PlatformViewFactory {

    private Context context;
    private Bundle savedInstanceState;

    @Override
    public IPlatformView getPlatformView(String xComponentId) {
        IPlatformView pv = null;
        switch (xComponentId){
            case "PlatformViewTest1":
                pv = new MyMapWrapper(context, savedInstanceState);
                break;
        }
        return pv;
    }

    public void setContext(Context context) {
        this.context = context;
    }

    public void setSavedInstanceState(Bundle savedInstanceState) {
        this.savedInstanceState = savedInstanceState;
    }
}
