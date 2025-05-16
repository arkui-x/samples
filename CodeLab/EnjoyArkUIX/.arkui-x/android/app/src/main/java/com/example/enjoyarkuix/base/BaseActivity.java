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

package com.example.enjoyarkuix.base;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.example.enjoyarkuix.R;

/**
 * BaseActivity
 *
 * @since 20
 */
public class BaseActivity extends AppCompatActivity {
    private TextView tvTopBarTitle;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    /**
     * Initializes the top bar of the activity with the given title.
     *
     * @param title The title to be displayed in the top bar.
     */
    protected void initTopBar(String title) {
        ImageView ivTopBarBack = findViewById(R.id.ivTopBarBack);
        if (ivTopBarBack instanceof ImageView) {
            ivTopBarBack.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    finish();
                }
            });
        }
        tvTopBarTitle = findViewById(R.id.tvTopBarTitle);
        if (tvTopBarTitle instanceof TextView) {
            tvTopBarTitle.setText(title);
        }
    }

    /**
     * setTvTopBarTitle
     *
     * @param title title
     */
    protected void setTvTopBarTitle(String title) {
        if (tvTopBarTitle != null) {
            tvTopBarTitle.setText(title);
        }
    }
}
