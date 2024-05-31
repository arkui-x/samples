package com.example.test;

import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.provider.MediaStore;
import android.util.Log;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

import com.google.gson.Gson;

import ohos.ace.adapter.capability.bridge.MethodData;

/**
 * 获取相册和视频资源，并传递给arkui端
 */
public class AlbumStore {
    private Context context;
    private Bridge bridge;

    private Integer pageNo = 1;//首页所有tab的pageNo
    private Integer page3dNo = 1;//首页近3天tab的pageNo
    private Integer page7dNo = 1;//首页近7天tab的pageNo
    private Integer page30dNo = 1;//首页近30天tab的pageNo
    private Integer xcPageNo = 1;//相册分类的页数：图片、截屏、视频的pageNo
    private Integer pageSize = 30;
    private ArrayList<Resource> allRes;

    public AlbumStore(Context context,Bridge bridge) {
        this.context = context;
        this.bridge = bridge;
    }

    // 获取相册中的全部资源并分局分类
    public void getImagesAndVideos() {

        this.getImagesAndVideosSortedByDate("photos");
        ArrayList<Resource> photos = new ArrayList<Resource>(allRes);

        this.getImagesAndVideosSortedByDate("screenshots");
        ArrayList<Resource> screenshots = new ArrayList<Resource>(allRes);

        this.getImagesAndVideosSortedByDate("videos");
        ArrayList<Resource> videos = new ArrayList<Resource>(allRes);

        Log.d("HiHelloWorld", String.valueOf(photos.size()));
        Log.d("HiHelloWorld", String.valueOf(screenshots.size()));
        Log.d("HiHelloWorld", String.valueOf(videos.size()));

        HashMap<String, Object> map = new HashMap<>();
        if(photos.size() > 0){
            map.put("photos", new String[]{ "file:/" + photos.get(0).uri });
        }
        map.put("photosSize", photos.size());
        if(screenshots.size() > 0){
            map.put("screenshots", new String[]{ "file:/" + screenshots.get(0).uri });
        }
        map.put("screenshotsSize", screenshots.size());
        if(videos.size() > 0){
            map.put("videos", new String[]{ "file:/" + videos.get(0).uri });
        }
        map.put("videosSize", videos.size());

        Gson gson = new Gson();
        String mapJson = gson.toJson(map);

        Object[] obj = new Object[]{mapJson};

        Log.d("HiHelloWorld", Arrays.toString(obj));
        MethodData methodData = new MethodData("getImagesAndVideos", obj);
        this.bridge.callMethod(methodData);
    }

    // 分页获取相册中的资源
    public void getImagesAndVideosByPage() {

        this.getImagesAndVideosSortedByDate("all");


        int startIndex = (pageNo - 1) * pageSize; // 计算这一页开始显示的资源的索引位置
        int endIndex = Math.min(startIndex + pageSize, allRes.size()); // 计算这一页结束显示的资源的索引位置，确保不会超过资源总数
        List<Resource> pageRes = new ArrayList<Resource>();
        if(startIndex < endIndex) {
            pageRes = allRes.subList(startIndex, endIndex); // 获取这一页的资源列表
        }

        for (Resource res : pageRes) {
            res.uri = "file:/" + res.uri;
        }

        Gson gson = new Gson();
        String pageResJson = gson.toJson(pageRes);
        Log.d("HiHelloWorld", pageResJson);
        this.bridge.sendMessageFromAndroid(pageResJson);
    }

    // 分页获取近3天相册中的资源
    public void get3dImagesAndVideosByPage() {

        this.getImagesAndVideosSortedByDate("all");

        // 获取当前日期和时间
        LocalDateTime now = LocalDateTime.now();
        // 计算3天前的日期和时间
        LocalDateTime threeDaysAgo = now.minusDays(3);
        // 将日期和时间转换为时间戳
        long timestamp = threeDaysAgo.toEpochSecond(ZoneOffset.UTC);
        System.out.println("3天前的时间戳：" + timestamp);
        List<Resource> recent3dRes = new ArrayList<>();
        for (Resource res : allRes) {
            if (res.createTime >= timestamp) {
                recent3dRes.add(res);
            }
        }

        int startIndex = (page3dNo - 1) * pageSize; // 计算这一页开始显示的资源的索引位置
        int endIndex = Math.min(startIndex + pageSize, recent3dRes.size()); // 计算这一页结束显示的资源的索引位置，确保不会超过资源总数
        List<Resource> pageRes = new ArrayList<Resource>();
        if(startIndex < endIndex) {
            pageRes = recent3dRes.subList(startIndex, endIndex); // 获取这一页的资源列表
        }

        for (Resource res : pageRes) {
            res.uri = "file:/" + res.uri;
        }

        Gson gson = new Gson();
        String pageResJson = gson.toJson(pageRes);
        Log.d("HiHelloWorld", pageResJson);
        this.bridge.sendMessageFromAndroid(pageResJson);
    }

    // 分页获取近7天相册中的资源
    public void get7dImagesAndVideosByPage() {

        this.getImagesAndVideosSortedByDate("all");

        // 获取当前日期和时间
        LocalDateTime now = LocalDateTime.now();
        // 计算7天前的日期和时间
        LocalDateTime sevenDaysAgo = now.minusDays(7);
        // 将日期和时间转换为时间戳
        long timestamp = sevenDaysAgo.toEpochSecond(ZoneOffset.UTC);
        System.out.println("7天前的时间戳：" + timestamp);
        List<Resource> recent7dRes = new ArrayList<>();
        for (Resource res : allRes) {
            if (res.createTime >= timestamp) {
                recent7dRes.add(res);
            }
        }

        int startIndex = (page7dNo - 1) * pageSize; // 计算这一页开始显示的资源的索引位置
        int endIndex = Math.min(startIndex + pageSize, recent7dRes.size()); // 计算这一页结束显示的资源的索引位置，确保不会超过资源总数
        List<Resource> pageRes = new ArrayList<Resource>();
        if(startIndex < endIndex) {
            pageRes = recent7dRes.subList(startIndex, endIndex); // 获取这一页的资源列表
        }

        for (Resource res : pageRes) {
            res.uri = "file:/" + res.uri;
        }

        Gson gson = new Gson();
        String pageResJson = gson.toJson(pageRes);
        Log.d("HiHelloWorld", pageResJson);
        this.bridge.sendMessageFromAndroid(pageResJson);
    }

    // 分页获取近30天相册中的资源
    public void get30dImagesAndVideosByPage() {

        this.getImagesAndVideosSortedByDate("all");

        // 获取当前日期和时间
        LocalDateTime now = LocalDateTime.now();
        // 计算30天前的日期和时间
        LocalDateTime thirtyDaysAgo = now.minusDays(30);
        // 将日期和时间转换为时间戳
        long timestamp = thirtyDaysAgo.toEpochSecond(ZoneOffset.UTC);
        System.out.println("30天前的时间戳：" + timestamp);
        List<Resource> recent30dRes = new ArrayList<>();
        for (Resource res : allRes) {
            if (res.createTime >= timestamp) {
                recent30dRes.add(res);
            }
        }

        int startIndex = (page30dNo - 1) * pageSize; // 计算这一页开始显示的资源的索引位置
        int endIndex = Math.min(startIndex + pageSize, recent30dRes.size()); // 计算这一页结束显示的资源的索引位置，确保不会超过资源总数
        List<Resource> pageRes = new ArrayList<Resource>();
        if(startIndex < endIndex) {
            pageRes = recent30dRes.subList(startIndex, endIndex); // 获取这一页的资源列表
        }

        for (Resource res : pageRes) {
            res.uri = "file:/" + res.uri;
        }

        Gson gson = new Gson();
        String pageResJson = gson.toJson(pageRes);
        Log.d("HiHelloWorld", pageResJson);
        this.bridge.sendMessageFromAndroid(pageResJson);
    }

    // 分页获取相册中的图片
    public void getPhotosByPage() {

        this.getImagesAndVideosSortedByDate("photos");

        int startIndex = (xcPageNo - 1) * pageSize; // 计算这一页开始显示的资源的索引位置
        int endIndex = Math.min(startIndex + pageSize, allRes.size()); // 计算这一页结束显示的资源的索引位置，确保不会超过资源总数
        List<Resource> pageRes = new ArrayList<Resource>();
        if(startIndex < endIndex) {
            pageRes = allRes.subList(startIndex, endIndex); // 获取这一页的资源列表
        }

        for (Resource res : pageRes) {
            res.uri = "file:/" + res.uri;
        }

        Gson gson = new Gson();
        String pageResJson = gson.toJson(pageRes);
        Log.d("HiHelloWorld", pageResJson);
        this.bridge.sendMessageFromAndroid(pageResJson);
    }

    // 分页获取相册中的截屏图片
    public void getScreenshotsByPage() {

        this.getImagesAndVideosSortedByDate("screenshots");

        int startIndex = (xcPageNo - 1) * pageSize; // 计算这一页开始显示的资源的索引位置
        int endIndex = Math.min(startIndex + pageSize, allRes.size()); // 计算这一页结束显示的资源的索引位置，确保不会超过资源总数
        List<Resource> pageRes = new ArrayList<Resource>();
        if(startIndex < endIndex) {
            pageRes = allRes.subList(startIndex, endIndex); // 获取这一页的资源列表
        }

        for (Resource res : pageRes) {
            res.uri = "file:/" + res.uri;
        }

        Gson gson = new Gson();
        String pageResJson = gson.toJson(pageRes);
        Log.d("HiHelloWorld", pageResJson);
        this.bridge.sendMessageFromAndroid(pageResJson);
    }

    // 分页获取相册中的图片
    public void getVideosByPage() {

        this.getImagesAndVideosSortedByDate("videos");

        int startIndex = (xcPageNo - 1) * pageSize; // 计算这一页开始显示的资源的索引位置
        int endIndex = Math.min(startIndex + pageSize, allRes.size()); // 计算这一页结束显示的资源的索引位置，确保不会超过资源总数
        List<Resource> pageRes = new ArrayList<Resource>();
        if(startIndex < endIndex) {
            pageRes = allRes.subList(startIndex, endIndex); // 获取这一页的资源列表
        }

        for (Resource res : pageRes) {
            res.uri = "file:/" + res.uri;
        }

        Gson gson = new Gson();
        String pageResJson = gson.toJson(pageRes);
        Log.d("HiHelloWorld", pageResJson);
        this.bridge.sendMessageFromAndroid(pageResJson);
    }

    // 获取相册中的所有资源，并按时间进行排序
    public void getImagesAndVideosSortedByDate(String type) {
        allRes = new ArrayList<Resource>();
        ContentResolver contentResolver = context.getContentResolver();

        // 获取图片的cursor
        Cursor imageCursor = contentResolver.query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, null, null, null, MediaStore.Images.Media._ID + " DESC");
        if(type != "videos") {
            while (imageCursor.moveToNext()) {
                String imageUriString = imageCursor.getString(imageCursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA));
                long imageCreateTime = imageCursor.getLong(imageCursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATE_ADDED));
                allRes.add(new Resource(imageUriString, imageCreateTime));
            }
        }

        if(type == "all" || type == "videos") {
            // 获取视频的cursor
            Cursor videoCursor = contentResolver.query(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, null, null, null, MediaStore.Video.Media._ID + " DESC");
            while (videoCursor.moveToNext()) {
                String videoUriString = videoCursor.getString(videoCursor.getColumnIndexOrThrow(MediaStore.Video.Media.DATA));
                long videoCreateTime = videoCursor.getLong(videoCursor.getColumnIndexOrThrow(MediaStore.Video.Media.DATE_ADDED));
                allRes.add(new Resource(videoUriString, videoCreateTime));
            }
        }

        if(type == "screenshots") {
            allRes = allRes.stream()
                    .filter(resource -> resource.getUri().toLowerCase().contains("screenshot"))
                    .collect(Collectors.toCollection(ArrayList::new));
        }

        // 根据创建时间对资源进行排序（倒序）
        Collections.sort(allRes, new Comparator<Resource>() {
            @Override
            public int compare(Resource o1, Resource o2) {
                return Long.compare(o2.createTime, o1.createTime);
            }
        });

    }

    public void setNextPageNo() {
        this.pageNo += 1;
    }
    public void setNext3dPageNo() {
        this.page3dNo += 1;
    }
    public void setNext7dPageNo() {
        this.page7dNo += 1;
    }
    public void setNext30dPageNo() {
        this.page30dNo += 1;
    }
    public void setNextXcPageNo() {
        this.xcPageNo += 1;
    }

    public void resetXcPageNo() {
        this.xcPageNo = 1;
    }
}

class Resource implements Cloneable {
    public String uri;
    public long createTime;

    public Resource(String uri, long createTime) {
        this.uri = uri;
        this.createTime = createTime;
    }

    public String getUri() {
        return uri;
    }

    @Override
    protected Object clone() throws CloneNotSupportedException {
        Resource resource = (Resource) super.clone();
        // 对每个成员变量进行深拷贝
        resource.uri = this.uri;
        resource.createTime = this.createTime;
        return resource;
    }
}
