package com.example.electronicalbum;

import android.content.Context;

// 引用平台桥接模块
import ohos.ace.adapter.capability.bridge.BridgePlugin;
import ohos.ace.adapter.capability.bridge.IMessageListener;

public class Bridge extends BridgePlugin implements IMessageListener {
    public Bridge(Context context, String name, int id) {
        super(context, name, id);

        setMessageListener(this);
    }

    // Android侧方法，供ArkUI侧调用
    public String getHelloArkUI() {
        return "Hello ArkUI!";
    }

    // 注册回调，接收ArkUI侧发来的数据
    @Override
    public Object onMessage(Object object) {
        return "java onMessage success";
    }

    @Override
    public void onMessageResponse(Object object) {}
}