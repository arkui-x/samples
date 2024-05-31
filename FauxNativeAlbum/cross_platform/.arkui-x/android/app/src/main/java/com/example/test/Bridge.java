package com.example.test;

import android.content.Context;
import android.util.Log;

import ohos.ace.adapter.capability.bridge.BridgePlugin;
import ohos.ace.adapter.capability.bridge.IMessageListener;
import ohos.ace.adapter.capability.bridge.MethodData;

public class Bridge extends BridgePlugin implements IMessageListener {

    EntryEntryAbilityActivity entryEntryAbilityActivity;
    public Bridge(Context context, String name, int id,EntryEntryAbilityActivity entryEntryAbilityActivity) {
        super(context, name, id);
        setMessageListener(this);
        this.entryEntryAbilityActivity = entryEntryAbilityActivity;
    }

    //Android 侧调用arkui侧的方法
    public void getScreenInfo(Object[] obj) {
        MethodData methodData = new MethodData("getScreenInfo", obj);
        this.callMethod(methodData);
    }

    //Android侧向arkui侧发送消息
    public void sendMessageFromAndroid(Object obj) {
        this.sendMessage(obj);
    }
    
    public String resetAlbum() {
        this.entryEntryAbilityActivity.resetAlbum();
        return "get resetAlbum From Android!";
    }

    public String getAlbumRes() {
        this.entryEntryAbilityActivity.getAlbumRes();
        return "get getAlbumRes From Android!";
    }

    // 分页获取相册中的资源
    public String getAlbumResByPage() {
        this.entryEntryAbilityActivity.getAlbumResByPage();
        return "get getAlbumResByPage From Android!";
    }

    // 获取下一页，分页获取相册中的资源
    public String getNextPageAlbumData() {
        this.entryEntryAbilityActivity.getNextPageAlbumData();
        return "get getNextPageAlbumData From Android!";
    }

    // 分页获取近3天相册中的资源
    public String get3dAlbumResByPage() {
        this.entryEntryAbilityActivity.get3dAlbumResByPage();
        return "get get3dAlbumResByPage From Android!";
    }

    // 获取下一页，分页获取近3天相册中的资源
    public String get3dNextPageAlbumData() {
        this.entryEntryAbilityActivity.get3dNextPageAlbumData();
        return "get get3dNextPageAlbumData From Android!";
    }

    // 分页获取近7天相册中的资源
    public String get7dAlbumResByPage() {
        this.entryEntryAbilityActivity.get7dAlbumResByPage();
        return "get get7dAlbumResByPage From Android!";
    }

    // 获取下一页，分页获取近7天相册中的资源
    public String get7dNextPageAlbumData() {
        this.entryEntryAbilityActivity.get7dNextPageAlbumData();
        return "get get7dNextPageAlbumData From Android!";
    }

    // 分页获取近30天相册中的资源
    public String get30dAlbumResByPage() {
        this.entryEntryAbilityActivity.get30dAlbumResByPage();
        return "get get30dAlbumResByPage From Android!";
    }

    // 获取下一页，分页获取近30天相册中的资源
    public String get30dNextPageAlbumData() {
        this.entryEntryAbilityActivity.get30dNextPageAlbumData();
        return "get get30dNextPageAlbumData From Android!";
    }

    public String getAlbumPhotos() {
        this.entryEntryAbilityActivity.getAlbumPhotos();
        return "get getAlbumPhotos From Android!";
    }

    public String getNextPageAlbumPhotos() {
        this.entryEntryAbilityActivity.getNextPageAlbumPhotos();
        return "get getNextPageAlbumPhotos From Android!";
    }

    public String getAlbumScreenshots() {
        this.entryEntryAbilityActivity.getAlbumScreenshots();
        return "get getAlbumScreenshots From Android!";
    }

    public String getNextPageAlbumScreenshots() {
        this.entryEntryAbilityActivity.getNextPageAlbumScreenshots();
        return "get getNextPageAlbumScreenshots From Android!";
    }

    public String getAlbumVideos() {
        this.entryEntryAbilityActivity.getAlbumVideos();
        return "get getAlbumVideos From Android!";
    }

    public String getNextPageAlbumVideos() {
        this.entryEntryAbilityActivity.getNextPageAlbumVideos();
        return "get getNextPageAlbumVideos From Android!";
    }

    public String getHelloArkUI() {
        return "Hello ArkUI From Android!";
    }

    // 注册回调，接收ArkUI侧发来的数据
    @Override
    public Object onMessage(Object object) {
        Log.e("HiHelloWorld", (String) object);
        return "java onMessage success and get album resource file";
    }

    @Override
    public void onMessageResponse(Object object) {
        Log.e("HiHelloWorld", "bridge log onMessageResponse");
        Log.e("HiHelloWorld", (String) object);
        System.out.print(object);
    }
}