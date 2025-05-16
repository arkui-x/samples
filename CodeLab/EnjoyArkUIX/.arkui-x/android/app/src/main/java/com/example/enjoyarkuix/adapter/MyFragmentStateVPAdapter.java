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

package com.example.enjoyarkuix.adapter;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;

import java.util.List;

/**
 * MyFragmentStateVPAdapter
 *
 * @since 20
 */

public class MyFragmentStateVPAdapter extends FragmentPagerAdapter {
    private List<Fragment> myFragmentList;

    public MyFragmentStateVPAdapter(@NonNull FragmentManager fm, List<Fragment> myFragmentList) {
        super(fm);
        this.myFragmentList = myFragmentList;
    }

    /**
     * 获取页面
     *
     * @param position  页面的位置
     * @return 返回具体页面
     */
    @NonNull
    @Override
    public Fragment getItem(int position) {
        return myFragmentList == null ? null : myFragmentList.get(position);
    }

    /**
     * 获取adapter内存储的页面个数
     *
     * @return int
     */
    @Override
    public int getCount() {
        return myFragmentList == null ? 0 : myFragmentList.size();
    }
}
