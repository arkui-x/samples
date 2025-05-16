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

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import androidx.fragment.app.Fragment;
import com.example.enjoyarkuix.activity.EntryEntryAbilityActivity;
import com.example.enjoyarkuix.activity.ShowActivity;
import com.example.enjoyarkuix.bean.ItemDataBean;
import com.example.enjoyarkuix.common.Constant;
import java.util.ArrayList;

/**
 * BasesFragment
 *
 * @since 20
 */

public class BasesFragment extends Fragment {
    private static final String LOG_TAG = "BasesFragment";

    /**
     * judgePage
     *
     * @param position position
     * @param arrayList arrayList
     */
    protected void judgePage(int position, ArrayList<ItemDataBean> arrayList) {
        ItemDataBean itemDataBean = arrayList.get(position);
        if (itemDataBean == null) {
            return;
        }
        int itemJudgeType = itemDataBean.getItemJudgeType();
        try {
            Intent intent = new Intent();
            Bundle bundle = new Bundle();
            bundle.putSerializable("ItemDataBean", itemDataBean); // 序列化
            intent.putExtras(bundle); // 发送数据
            if (itemJudgeType == Constant.JUDPT_SHOW_ACTIVITY) {
                intent.setClass(getContext(), ShowActivity.class);
            } else if (itemJudgeType == Constant.JUDPT_ENTRY_ENTRY_ABILITY_ACTIVITY) {
                intent.setClass(getContext(), EntryEntryAbilityActivity.class);
            } else if (itemJudgeType == Constant.JUDPT_ANDROID_ACTIVITY) {
                Class c = itemDataBean.getClz();
                if (c == null) {
                    return;
                }
                intent.setClass(getContext(), c);
            } else {
                return;
            }
            startActivity(intent);
        } catch (ActivityNotFoundException e) {
            Log.e(LOG_TAG, "Activity not found: " + e.toString());
        } catch (Exception e) {
            Log.e(LOG_TAG, "Unexpected exception: " + e.toString());
        }
    }
}
