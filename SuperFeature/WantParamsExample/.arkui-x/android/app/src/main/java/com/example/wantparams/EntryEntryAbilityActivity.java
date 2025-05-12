package com.example.wantparams;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import ohos.ace.adapter.WantParams;
import ohos.stage.ability.adapter.StageActivity;


/**
 * Example ace activity class, which will load ArkUI-X ability instance.
 * StageActivity is provided by ArkUI-X
 *
 * @since 2025-01-18
 * @see <a href=
 * "https://gitcode.com/arkui-x/docs/blob/master/zh-cn/application-dev/tutorial/how-to-integrate-arkui-into-android.md">
 * to build android library</a>
 */
public class EntryEntryAbilityActivity extends StageActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.e("HiHelloWorld", "EntryEntryAbilityActivity");
        WantParams wantParams = new WantParams();
        wantParams.addValue("stringKey", "normal")
                .addValue("intKey", 12345)
                .addValue("doubleKey", 1.23)
                .addValue("boolKey", true)
                .addValue("arrayKey", new String[] {"want", "Params"})
                .addValue("wantParamsKey",
                        new WantParams()
                                .addValue("intKey2", 4321));
        Intent intent = getIntent();
        intent.putExtra("params", wantParams.toWantParamsString());
        setInstanceName("com.example.wantparams:entry:EntryAbility:");
        super.onCreate(savedInstanceState);
    }
}
