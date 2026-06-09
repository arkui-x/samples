package com.example.enjoyarkuix;

import android.os.Bundle;
import android.util.Log;

import ohos.stage.ability.adapter.StageActivity;

/**
 * Example ace activity class, which will load ArkUI-X ability instance.
 * StageActivity is provided by ArkUI-X
 *
 * @since 2026-05-25
 * @see <a href=
 * "https://gitee.com/arkui-x/docs/blob/master/zh-cn/application-dev/tutorial/how-to-integrate-arkui-into-android.md">
 * to build android library</a>
 */
public class EnableHapticFeedbackDemoEnableHapticFeedbackDemoAbilityActivity extends StageActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.e("HiHelloWorld", "EnableHapticFeedbackDemoEnableHapticFeedbackDemoAbilityActivity");

        setInstanceName("com.example.enjoyarkuix:EnableHapticFeedbackDemo:EnableHapticFeedbackDemoAbility: ");
        super.onCreate(savedInstanceState);
    }
}
