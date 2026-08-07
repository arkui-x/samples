package com.example.enjoyarkuix;

import android.os.Bundle;
import android.util.Log;

import ohos.stage.ability.adapter.StageActivity;

/**
 * This is a test demonstration activity, used for InteractionEffectTestDemo.
 *
 * Example ace activity class, which will load ArkUI-X ability instance.
 * StageActivity is provided by ArkUI-X
 *
 * @since 2026-08-04
 * @see <a href=
 * "https://gitee.com/arkui-x/docs/blob/master/zh-cn/application-dev/tutorial/how-to-integrate-arkui-into-android.md">
 * to build android library</a>
 */
public class InteractionEffectTestDemoInteractionEffectTestDemoAbilityActivity extends StageActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.e("HiHelloWorld", "InteractionEffectTestDemoInteractionEffectTestDemoAbilityActivity");

        setInstanceName("com.example.enjoyarkuix:InteractionEffectTestDemo:InteractionEffectTestDemoAbility:");
        super.onCreate(savedInstanceState);
    }
}
