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

package com.example.enjoyarkuix.stagefragment;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;
import androidx.viewpager.widget.ViewPager;

import com.example.enjoyarkuix.R;
import com.google.android.material.tabs.TabLayout;

import java.util.ArrayList;
import java.util.List;

/**
 * ViewPagerFragmentActivity
 *
 * @since 20
 */
public class ViewPagerFragmentActivity extends FragmentActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_single_viewpager_fragment);
        View ivTopBarBackView = findViewById(R.id.ivTopBarBack);
        if (ivTopBarBackView instanceof ImageView) {
            ImageView ivTopBarBack = (ImageView) ivTopBarBackView;
            ivTopBarBack.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    finish();
                }
            });
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
        List<Fragment> fragments = new ArrayList<>();
        fragments.add(new ViewFragment());
        fragments.add(new NativeFragment());
        TabLayout tabLayout = findViewById(R.id.tabLayout);
        ViewPager viewPager = findViewById(R.id.viewPager);

        TitleFragmentPagerAdapter adapter = new TitleFragmentPagerAdapter(getSupportFragmentManager(), fragments,
                new String[] {"ArkuiFragment", "AndroidFragment"});
        viewPager.setAdapter(adapter);

        tabLayout.setupWithViewPager(viewPager);
    }

    /**
     * TitleFragmentPagerAdapter
     *
     * @since 2025-05-12
     */
    public class TitleFragmentPagerAdapter extends FragmentPagerAdapter {
        private List<Fragment> mFragmentList = null;

        private String[] titles;

        public TitleFragmentPagerAdapter(FragmentManager mFragmentManager,
                List<Fragment> fragmentList, String[] titles) {
            super(mFragmentManager);
            mFragmentList = fragmentList;
            this.titles = titles;
        }

        @Override
        public int getCount() {
            return mFragmentList.size();
        }

        @Override
        public Fragment getItem(int position) {
            Fragment fragment = null;
            if (position < mFragmentList.size()) {
                fragment = mFragmentList.get(position);
            } else {
                fragment = mFragmentList.get(0);
            }
            return fragment;
        }

        @Override
        public CharSequence getPageTitle(int position) {
            if (titles != null && titles.length > 0) {
                return titles[position];
            }
            return null;
        }
    }
}
