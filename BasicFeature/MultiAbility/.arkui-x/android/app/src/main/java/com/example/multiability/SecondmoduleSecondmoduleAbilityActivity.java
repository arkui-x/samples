package com.example.multiability;

import android.os.Bundle;
import android.util.Log;

import ohos.stage.ability.adapter.StageActivity;

/**
 * Example ace activity class, which will load ArkUI-X ability instance.
 * StageActivity is provided by ArkUI-X
 *
 * @since 2025-01-15
 * @see <a href=
 * "https://gitcode.com/arkui-x/docs/blob/master/zh-cn/application-dev/tutorial/how-to-integrate-arkui-into-android.md">
 * build library</a>
 */
public class SecondmoduleSecondmoduleAbilityActivity extends StageActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.e("HiHelloWorld", "SecondmoduleSecondmoduleAbilityActivity");
        setInstanceName("com.example.multiability:secondmodule:SecondmoduleAbility:");
        super.onCreate(savedInstanceState);
    }
}
