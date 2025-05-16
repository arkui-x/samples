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
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import com.example.enjoyarkuix.R;
import com.example.enjoyarkuix.adapter.MyItemRecyclerViewAdapter;
import com.example.enjoyarkuix.bean.ItemDataBean;
import com.example.enjoyarkuix.common.Constant;
import com.example.enjoyarkuix.interfaces.OnItemClickListener;
import java.util.ArrayList;

/**
 * SelfTestFragment
 *
 * @since 20
 */
public class SelfTestFragment extends BasesFragment {
    /**
     * Creates a new instance of the SelfTestFragment.
     *
     * @return a new instance of SelfTestFragment
     */
    @SuppressWarnings("unused")

    public static SelfTestFragment newInstance() {
        return new SelfTestFragment();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_item_list, container, false);

        ArrayList<ItemDataBean> arrayList = new ArrayList();
        ItemDataBean itemDataBean0 = new ItemDataBean("自测试Demo", Constant.JUDPT_ENTRY_ENTRY_ABILITY_ACTIVITY, "Test",
                "TestAbility");
        arrayList.add(itemDataBean0);
        // Set the adapter
        Context context = view.getContext();
        RecyclerView recyclerView = (RecyclerView) view.findViewById(R.id.list);
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