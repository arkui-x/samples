package com.example.electronicalbum;

import android.content.pm.PackageManager;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.util.ArrayList;
import java.util.List;

import ohos.stage.ability.adapter.StageActivity;

public class BaseActivity extends StageActivity {

    public static final int REQUEST_CONDE =0xFFFF;

    /**
     * 动态请求权限(入口)
     * @param permissionNameList 需要授权的权限名称
     */
    public void requestPermission(List<String> permissionNameList){

        // TODO: 2023/2/22 第一步：排除（已经获得过授权的权限）=============================================================
        List<String> UnauthorizedPermissionNameList = new ArrayList<>();//用于存放未获得授权的权限
        for (String permission : permissionNameList){
            //检查每个权限是否已经获得授权
            int checkResult=ContextCompat.checkSelfPermission(this,permission);
            if (checkResult==PackageManager.PERMISSION_GRANTED){
                //已获得过授权,直接抛出结果true
                throwPermissionResults(permission,true);
            }else if (checkResult==PackageManager.PERMISSION_DENIED) {
                //未获得授权，把未获得授权的权限加入到thisPermissionNames中，待下一步请求
                UnauthorizedPermissionNameList.add(permission);
            }else {
                //按道理，这里永远不会发生，
                //因为checkSelfPermission方法说得很清楚，只会返回PERMISSION_GRANTED或者PERMISSION_DENIED
                //但是为了严谨，以防万一，还是给它抛出结果false
                throwPermissionResults("Unknown_result",false);
            }
        }
        if (UnauthorizedPermissionNameList.size()==0)return;//表示：全部已经拥有全选，不用往下执行

        // TODO: 2023/2/22 第二步：开始申请权限==========================================================================
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            //由于请求权限的参数必须是String[],所以List转到String[]中
            String[] UnauthorizedPermissionNames=new String[UnauthorizedPermissionNameList.size()];
            for (int k=0;k<UnauthorizedPermissionNameList.size();k++){
                UnauthorizedPermissionNames[k]=UnauthorizedPermissionNameList.get(k);
            }

            //请求权限
            ActivityCompat.requestPermissions(this, UnauthorizedPermissionNames, REQUEST_CONDE);
        }else {
            //低版本的Android不需要动态获取权限，这里直接抛出结果true
            throwPermissionResults("Below_VERSION_M",true);
        }
    }

    /**
     * 抛出授权结果（出口）
     * @param permissionName 权限名称
     * @param isSuccess 该权限是否获得授权（true:获得授权  false:未获得授权）
     */
    public void throwPermissionResults(String permissionName, boolean isSuccess){
        // TODO: 2023/2/22 这里如果isSuccess=false,可以自定义一个弹窗，让用户选择
        //  到底是要直接退出应用，还是去设置中开启权限,本文主要是总结动态获取权限，所以弹窗笔者就不写了
    }


    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        //判断我们的请求码，避免别的事件调用onRequestPermissionsResult,导致我们拿到本不该属于我们的数据
        if (requestCode==REQUEST_CONDE){
            // 如果请求被取消，则结果数组为空。
            if (grantResults.length > 0) {
                //循环一个一个地去判断结果
                for (int k=0;k<permissions.length;k++){

                    if (grantResults[k] == PackageManager.PERMISSION_GRANTED){
                        // 权限请求成功，抛出结果true
                        throwPermissionResults(permissions[k],true);
                    }

                    if (grantResults[k] == PackageManager.PERMISSION_DENIED){
                        // 权限请求失败，抛出结果false
                        throwPermissionResults(permissions[k],false);
                    }
                }
            } else {
                //没有任何授权结果,直接抛出结果false
                throwPermissionResults("Unknown_result",false);
            }
        }
    }

}


