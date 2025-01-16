package com.example.animation;

import android.os.Bundle;
import android.util.Log;

import ohos.stage.ability.adapter.StageActivity;


/**
 * Example ace activity class, which will load ArkUI-X ability instance.
 * StageActivity is provided by ArkUI-X
 *
 * @since 2025-01-07
 */
public class EntryEntryAbilityActivity extends StageActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.e("HiHelloWorld", "EntryEntryAbilityActivity");
        setInstanceName("com.example.animation:entry:EntryAbility:");
        super.onCreate(savedInstanceState);
    }
}
