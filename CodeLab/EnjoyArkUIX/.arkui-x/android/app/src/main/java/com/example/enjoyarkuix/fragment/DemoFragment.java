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

package com.example.enjoyarkuix.fragment;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import com.example.enjoyarkuix.R;
import com.example.enjoyarkuix.activity.DynamizationJumpActivity;
import com.example.enjoyarkuix.activity.FragmentEntryActivity;
import com.example.enjoyarkuix.adapter.MyItemRecyclerViewAdapter;
import com.example.enjoyarkuix.bean.ItemDataBean;
import com.example.enjoyarkuix.common.Constant;
import com.example.enjoyarkuix.interfaces.OnItemClickListener;
import java.util.ArrayList;

/**
 * A simple {@link Fragment} subclass.
 * Use the {@link DemoFragment#newInstance} factory method to
 * create an instance of this fragment.
 *
 * @since 20
 */
public class DemoFragment extends BasesFragment {
    /**
     * Creates a new instance of the DemoFragment.
     *
     * @return A new instance of DemoFragment.
     */
    public static DemoFragment newInstance() {
        return new DemoFragment();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_demo, container, false);

        // Prepare the data list
        ArrayList<ItemDataBean> arrayList = new ArrayList<>();
        arrayList.add(new ItemDataBean("fragment跨平台", Constant.JUDPT_ANDROID_ACTIVITY,
            FragmentEntryActivity.class));
        arrayList.add(new ItemDataBean("Bridge跨平台", Constant.JUDPT_ENTRY_ENTRY_ABILITY_ACTIVITY,
            "PlatformBridge", "PlatformBridgeAbility"));
        arrayList.add(new ItemDataBean("PlatformView跨平台", Constant.JUDPT_ENTRY_ENTRY_ABILITY_ACTIVITY,
            "PlatformView", "PlatformViewAbility"));
        arrayList.add(new ItemDataBean("动态化跨平台", Constant.JUDPT_ANDROID_ACTIVITY,
            DynamizationJumpActivity.class));
        // Set the adapter
        Context context = view.getContext();
        RecyclerView recyclerView = view.findViewById(R.id.list);
        recyclerView.setLayoutManager(new LinearLayoutManager(context));
        MyItemRecyclerViewAdapter myItemRecyclerViewAdapter = new MyItemRecyclerViewAdapter(arrayList);
        recyclerView.setAdapter(myItemRecyclerViewAdapter);

        myItemRecyclerViewAdapter.setOnItemClickListener(new OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                judgePage(position, arrayList);
            }
        });

        return view;
    }
}