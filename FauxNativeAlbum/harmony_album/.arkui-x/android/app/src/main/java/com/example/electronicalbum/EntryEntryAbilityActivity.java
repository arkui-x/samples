package com.example.electronicalbum;

import android.Manifest;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import java.util.ArrayList;
import java.util.List;

/**
 * Example ace activity class, which will load ArkUI-X ability instance.
 * StageActivity is provided by ArkUI-X
 * @see <a href=
 * "https://gitee.com/arkui-crossplatform/doc/blob/master/contribute/tutorial/how-to-build-Android-app.md">
 * to build android library</a>
 */
public class EntryEntryAbilityActivity extends BaseActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // 建立与ArkUI侧同名的平台桥接，即可用于消息传递
        new Bridge(this, "Bridge", getInstanceId());
        Log.e("HiHelloWorld", "EntryEntryAbilityActivity");
        setInstanceName("com.zrgj.album:entry:EntryAbility:");

        super.onCreate(savedInstanceState);

//        setContentView(R.layout.activity_main);


        //列好所有我们需要的权限
        List<String> perList=new ArrayList<>();
        perList.add(Manifest.permission.CAMERA);
        perList.add(Manifest.permission.READ_EXTERNAL_STORAGE);
        perList.add(Manifest.permission.WRITE_EXTERNAL_STORAGE);
//        开始请求权限
        requestPermission(perList);


    }

    @Override
    public void throwPermissionResults(String permissionName, boolean isSuccess) {
        super.throwPermissionResults(permissionName, isSuccess);
        //拿到相应的权限，以及授权结果
        switch (permissionName){
            case Manifest.permission.CAMERA:
                Log.d("fxHou","CAMERA授权结果："+isSuccess);
                break;
            case Manifest.permission.READ_EXTERNAL_STORAGE:
                Log.d("fxHou","READ_EXTERNAL_STORAGE授权结果："+isSuccess);
                break;
            case Manifest.permission.WRITE_EXTERNAL_STORAGE:
                Log.d("fxHou","WRITE_EXTERNAL_STORAGE授权结果："+isSuccess);
                break;
        }
    }

    // READ_EXTERNAL_STORAGE、WRITE_EXTERNAL_STORAGE只有在真机上才能测试，模拟器不支持
    public void getFiles(View view) {
        //列好所有我们需要的权限
        List<String> perList=new ArrayList<>();
        perList.add(Manifest.permission.CAMERA);
        perList.add(Manifest.permission.READ_EXTERNAL_STORAGE);
        perList.add(Manifest.permission.WRITE_EXTERNAL_STORAGE);
        //开始请求权限
        requestPermission(perList);
    }

}

