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

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import com.example.enjoyarkuix.R;
import com.example.enjoyarkuix.adapter.MyItemRecyclerViewAdapter;
import com.example.enjoyarkuix.base.BaseActivity;
import com.example.enjoyarkuix.bean.ItemDataBean;
import com.example.enjoyarkuix.common.Constant;
import com.example.enjoyarkuix.interfaces.OnItemClickListener;
import java.util.ArrayList;
import java.util.Optional;

/**
 * ShowActivity
 *
 * @since 2025
 */
public class ShowActivity extends BaseActivity {
    private static final String TAG = "ShowActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_show);
        initTopBar("");

        Optional<ArrayList<ItemDataBean>> optionalData = prepareData();
        optionalData.ifPresent(this::initRecyclerView);
    }

    private Optional<ArrayList<ItemDataBean>> prepareData() {
        Intent intent = getIntent();
        if (intent == null) {
            return Optional.empty();
        }

        Object itemDataBeanObject = intent.getSerializableExtra("ItemDataBean");
        if (!(itemDataBeanObject instanceof ItemDataBean)) {
            return Optional.empty();
        }

        ItemDataBean itemDataBean = (ItemDataBean) itemDataBeanObject;
        int page = itemDataBean.getPage();
        if (page == Constant.VERSION_LIST) {
            ArrayList<ItemDataBean> arrayList = new ArrayList<>();
            arrayList.add(new ItemDataBean("特性1", Constant.JUDPT_ENTRY_ENTRY_ABILITY_ACTIVITY,
                    "Testversion", "TestversionAbility"));
            arrayList.add(new ItemDataBean("特性2", Constant.JUDPT_ENTRY_ENTRY_ABILITY_ACTIVITY,
                    "Testversion", "TestversionAbility"));
            setTvTopBarTitle("版本");
            return Optional.of(arrayList);
        }
        return Optional.empty();
    }

    private void initRecyclerView(ArrayList<ItemDataBean> arrayList) {
        View recyclerViewView = findViewById(R.id.recycleview);
        if (recyclerViewView instanceof RecyclerView) {
            RecyclerView recyclerView = (RecyclerView) recyclerViewView;
            recyclerView.setLayoutManager(new LinearLayoutManager(this));
            MyItemRecyclerViewAdapter myItemRecyclerViewAdapter = new MyItemRecyclerViewAdapter(arrayList);
            recyclerView.setAdapter(myItemRecyclerViewAdapter);
            myItemRecyclerViewAdapter.setOnItemClickListener(new OnItemClickListener() {
                @Override
                public void onItemClick(View view, int position) {
                    handleItemClick(arrayList.get(position));
                }
            });
        } else {
            Log.e("RecyclerViewInit", "The view is not an instance of RecyclerView");
        }
    }

    private void handleItemClick(ItemDataBean itemDataBean) {
        if (itemDataBean == null) {
            return;
        }
        int itemJudgeType = itemDataBean.getItemJudgeType();
        try {
            Intent intent = new Intent();
            Bundle bundle = new Bundle();
            bundle.putSerializable("ItemDataBean", itemDataBean); // 序列化
            intent.putExtras(bundle); // 发送数据
            switch (itemJudgeType) {
                case Constant.JUDPT_SHOW_ACTIVITY:
                    intent.setClass(this, ShowActivity.class);
                    break;
                case Constant.JUDPT_ENTRY_ENTRY_ABILITY_ACTIVITY:
                    intent.setClass(this, EntryEntryAbilityActivity.class);
                    break;
                case Constant.JUDPT_ANDROID_ACTIVITY:
                    Class<?> clazz = itemDataBean.getClz();
                    if (clazz != null) {
                        intent.setClass(this, clazz);
                    } else {
                        return;
                    }
                    break;
                default:
                    return;
            }
            startActivity(intent);
        } catch (ActivityNotFoundException e) {
            Log.e(TAG, "未找到活动：" + e.toString());
        }
    }
}