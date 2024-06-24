package com.example.test;

import android.Manifest;
import android.os.Bundle;
import android.util.Log;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * Example ace activity class, which will load ArkUI-X ability instance.
 * StageActivity is provided by ArkUI-X
 * @see <a href=
 * "https://gitee.com/arkui-crossplatform/doc/blob/master/contribute/tutorial/how-to-build-Android-app.md">
 * to build android library</a>
 */
public class EntryEntryAbilityActivity extends BaseActivity {
    private Bridge bridge;
    AlbumStore albumStore;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        // 建立与ArkUI侧同名的平台桥接，即可用于消息传递
        this.bridge = new Bridge(this, "Bridge", getInstanceId(),this);
        this.albumStore = new AlbumStore(this,this.bridge);
        Log.e("HiHelloWorld", "EntryEntryAbilityActivity");
        setInstanceName("com.example.test:entry:EntryAbility:");
        super.onCreate(savedInstanceState);
        this.getFilesPermission();
    }

    @Override
    public void throwPermissionResults(String permissionName, boolean isSuccess) {
        super.throwPermissionResults(permissionName, isSuccess);
        //拿到相应的权限，以及授权结果
        switch (permissionName){
            case Manifest.permission.READ_EXTERNAL_STORAGE:
                Log.d("HiHelloWorld","READ_EXTERNAL_STORAGE授权结果："+isSuccess);
                break;
            case Manifest.permission.WRITE_EXTERNAL_STORAGE:
//                this.bridge.sendMessageFromAndroid();
                Log.d("HiHelloWorld","WRITE_EXTERNAL_STORAGE授权结果："+isSuccess);
                this.getAlbumRes();
                this.getAlbumResByPage();
                break;
        }
    }

    public void resetAlbum() {
        albumStore.resetXcPageNo();
    }

    // 获取相册内的所有资源
    public void getAlbumRes() {
        albumStore.getImagesAndVideos();
    }

    // 分页获取相册内的所有资源
    public void getAlbumResByPage() {
        albumStore.getImagesAndVideosByPage();
        this.getScreenDensity();
    }

    // 分页获取相册内的所有资源
    public void get3dAlbumResByPage() {
        albumStore.get3dImagesAndVideosByPage();
    }

    // 分页获取相册内的所有资源
    public void get7dAlbumResByPage() {
        albumStore.get7dImagesAndVideosByPage();
    }

    // 分页获取相册内的所有资源
    public void get30dAlbumResByPage() {
        albumStore.get30dImagesAndVideosByPage();
    }

    // 分页获取相册内的所有图片
    public void getAlbumPhotos() {
        albumStore.getPhotosByPage();
    }

    // 分页获取相册内的所有截屏
    public void getAlbumScreenshots() {
        albumStore.getScreenshotsByPage();
    }

    // 分页获取相册内的所有视频
    public void getAlbumVideos() {
        albumStore.getVideosByPage();
    }

    public void getNextPageAlbumData() {
        albumStore.setNextPageNo();
        albumStore.getImagesAndVideosByPage();
    }

    public void get3dNextPageAlbumData() {
        albumStore.setNext3dPageNo();
        albumStore.get3dImagesAndVideosByPage();
    }

    public void get7dNextPageAlbumData() {
        albumStore.setNext7dPageNo();
        albumStore.get7dImagesAndVideosByPage();
    }

    public void get30dNextPageAlbumData() {
        albumStore.setNext30dPageNo();
        albumStore.get30dImagesAndVideosByPage();
    }

    public void getNextPageAlbumPhotos() {
        albumStore.setNextXcPageNo();
        albumStore.getPhotosByPage();
    }

    public void getNextPageAlbumScreenshots() {
        albumStore.setNextXcPageNo();
        albumStore.getScreenshotsByPage();
    }

    public void getNextPageAlbumVideos() {
        albumStore.setNextXcPageNo();
        albumStore.getVideosByPage();
    }

    // 获取屏幕信息density
    public void getScreenDensity() {
        Map<String, Object> density = new HashMap<>();
        density.put("density", getDensity());
        Object[] values = density.values().toArray();
        this.bridge.getScreenInfo(values);
    }

    // READ_EXTERNAL_STORAGE、WRITE_EXTERNAL_STORAGE只有在真机上才能测试，模拟器不支持
    public void getFilesPermission() {
        //列好所有我们需要的权限
        List<String> perList=new ArrayList<>();
        perList.add(Manifest.permission.READ_MEDIA_IMAGES);
        perList.add(Manifest.permission.READ_MEDIA_VIDEO);
        perList.add(Manifest.permission.READ_EXTERNAL_STORAGE);
        perList.add(Manifest.permission.WRITE_EXTERNAL_STORAGE);
        //开始请求权限
        requestPermission(perList);
    }

}
