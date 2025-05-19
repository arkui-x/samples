/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.example.enjoyarkuix.activity;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import com.example.enjoyarkuix.R;
import com.example.enjoyarkuix.stagefragment.ArkuiFragment;
import com.example.enjoyarkuix.stagefragment.NativeFragment;
import com.google.android.material.tabs.TabLayout;

/**
 * FragmentManagerActivity
 *
 * @since 20
 */

public class FragmentManagerActivity extends AppCompatActivity {
    ArkuiFragment arkuiFragment;
    NativeFragment nativeFragment;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_fragment_manager);
        initTopBar();
        initFragments();
        setupTabLayout();
    }
    private void initTopBar() {
        View ivTopBarBackView = findViewById(R.id.ivTopBarBack);
        if (ivTopBarBackView instanceof ImageView) {
            ImageView ivTopBarBack = (ImageView) ivTopBarBackView;
            ivTopBarBack.setOnClickListener(view -> finish());
        } else {
            Log.e("TopBarInit", "ivTopBarBack is not an instance of ImageView");
        }
        View titleView = findViewById(R.id.tvTopBarTitle);
        if (titleView instanceof TextView) {
            TextView title = (TextView) titleView;
            title.setText("Android Activity");
        } else {
            Log.e("TopBarInit", "tvTopBarTitle is not an instance of TextView");
        }
    }
    private void initFragments() {
        arkuiFragment = new ArkuiFragment();
        nativeFragment = new NativeFragment();
        FragmentManager manager = getSupportFragmentManager();
        manager.beginTransaction().add(R.id.app_fragment_container, arkuiFragment).commit();
    }
    private void setupTabLayout() {
        TabLayout tabLayout = findViewById(R.id.tabLayout);
        tabLayout.addTab(tabLayout.newTab().setText("ArkuiFragment"));
        tabLayout.addTab(tabLayout.newTab().setText("原生Fragment"));
        tabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
                int position = tab.getPosition();
                if (position == 0) {
                    switchFragment(arkuiFragment, nativeFragment, transaction);
                } else {
                    switchFragment(nativeFragment, arkuiFragment, transaction);
                }
                transaction.commit();
            }
            @Override
            public void onTabUnselected(TabLayout.Tab tab) {
            }
            @Override
            public void onTabReselected(TabLayout.Tab tab) {
            }
        });
    }
    private void switchFragment(Fragment showFragment, Fragment hideFragment, FragmentTransaction transaction) {
        if (showFragment.isAdded()) {
            transaction.show(showFragment);
        } else {
            transaction.add(R.id.app_fragment_container, showFragment);
        }
        if (hideFragment.isAdded()) {
            transaction.hide(hideFragment);
        }
    }
}