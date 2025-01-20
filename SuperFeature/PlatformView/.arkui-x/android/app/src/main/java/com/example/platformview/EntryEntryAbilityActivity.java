package com.example.platformview;

import android.os.Bundle;
import android.util.Log;

import com.amap.api.location.AMapLocationClient;
import com.amap.api.maps.MapsInitializer;

import ohos.stage.ability.adapter.StageActivity;
/**
 * Example ace activity class, which will load ArkUI-X ability instance.
 * StageActivity is provided by ArkUI-X
 * @see <a href=
 * "https://gitee.com/arkui-crossplatform/doc/blob/master/contribute/tutorial/how-to-build-Android-app.md">
 * to build android library</a>
 */
public class EntryEntryAbilityActivity extends StageActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.e("HiHelloWorld", "EntryEntryAbilityActivity");
        setInstanceName("com.example.platformview:entry:EntryAbility:");
        super.onCreate(savedInstanceState);

        AMapLocationClient.updatePrivacyShow(this, true, true);
        AMapLocationClient.updatePrivacyAgree(this, true);

        MapsInitializer.updatePrivacyShow(this, true, true);
        MapsInitializer.updatePrivacyAgree(this, true);

        MyPlatformViewFactory platformViewFactory = new MyPlatformViewFactory();
        platformViewFactory.setContext(this);
        platformViewFactory.setSavedInstanceState(savedInstanceState);
        registerPlatformViewFactory(platformViewFactory);
    }
}
