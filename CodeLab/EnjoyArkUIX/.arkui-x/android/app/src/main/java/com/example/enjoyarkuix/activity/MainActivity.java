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
import android.view.MenuItem;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;
import com.example.enjoyarkuix.R;
import com.example.enjoyarkuix.adapter.MyFragmentStateVPAdapter;
import com.example.enjoyarkuix.fragment.DemoFragment;
import com.example.enjoyarkuix.fragment.SelfTestFragment;
import com.example.enjoyarkuix.fragment.VersionFragment;
import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.android.material.navigation.NavigationBarView;

import java.util.ArrayList;
import java.util.List;

/**
 * MainActivity
 *
 * @since 20
 */

public class MainActivity extends AppCompatActivity {
    private ViewPager mViewPager; // 主页面来展示子页面 Viewpager
    private BottomNavigationView mBottomNavigationView; // 主页面底部tab按钮

    private List<Fragment> mFragmentList; // 存储fragment页面，用来作为构造adapter的参数
    private MyFragmentStateVPAdapter mStateVPAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initeView();
        initData();
        setFListener();
        setBListener();
    }

    // 反向处理，按钮设置点击事件，按钮关联页面
    private void setBListener() {
        mBottomNavigationView.setOnItemSelectedListener(new NavigationBarView.OnItemSelectedListener() {
            @Override
            public boolean onNavigationItemSelected(@NonNull MenuItem item) {
                if (item.getItemId() == R.id.menu_usecase) {
                    mViewPager.setCurrentItem(0);
                } else if (item.getItemId() == R.id.menu_recommend) {
                    mViewPager.setCurrentItem(1);
                } else if (item.getItemId() == R.id.menu_mine) {
                    mViewPager.setCurrentItem(2);
                } else {
                    Log.e("NavigationItem", "Unexpected item ID: " + item.getItemId());
                }
                return true;
            }
        });
    }

    private void setFListener() {
        mStateVPAdapter = new MyFragmentStateVPAdapter(getSupportFragmentManager(), mFragmentList);
        mViewPager.setAdapter(mStateVPAdapter);
        mViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
            }

            @Override
            public void onPageSelected(int position) {
                onPagerSelected(position);
            }

            @Override
            public void onPageScrollStateChanged(int state) {
            }
        });
    }

    private void onPagerSelected(int position) {
        switch (position) {
            case 0:
                mBottomNavigationView.setSelectedItemId(R.id.menu_usecase);
                break;
            case 1:
                mBottomNavigationView.setSelectedItemId(R.id.menu_recommend);
                break;
            case 2:
                mBottomNavigationView.setSelectedItemId(R.id.menu_mine);
                break;
            default:
                Log.e("onPagerSelected", "Unexpected position: " + position);
                break;
        }
    }

    private void initData() {
        mFragmentList = new ArrayList<>();
        SelfTestFragment useCaseFragment = SelfTestFragment.newInstance();
        DemoFragment recommendFragment = DemoFragment.newInstance();
        VersionFragment mineFragment = VersionFragment.newInstance();
        mFragmentList.add(useCaseFragment);
        mFragmentList.add(recommendFragment);
        mFragmentList.add(mineFragment);
    }

    private void initeView() {
        mViewPager = findViewById(R.id.vp);
        mBottomNavigationView = findViewById(R.id.bottom_nav_menu);
        mBottomNavigationView.setItemIconTintList(null);
    }
}