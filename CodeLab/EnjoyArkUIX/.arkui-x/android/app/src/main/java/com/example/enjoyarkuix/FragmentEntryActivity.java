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

package com.example.enjoyarkuix;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.example.enjoyarkuix.stagefragment.FragmentManagerActivity;
import com.example.enjoyarkuix.stagefragment.ViewPagerFragmentActivity;

/**
 * FragmentEntryActivity
 *
 * @since 20
 */
public class FragmentEntryActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_fragment_entry);
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
            Log.e("ActivityFragmentEntry", "ivTopBarBack is not an instance of ImageView");
        }

        View titleView = findViewById(R.id.tvTopBarTitle);
        if (titleView instanceof TextView) {
            TextView title = (TextView) titleView;
            title.setText("Fragment");
        } else {
            Log.e("ActivityFragmentEntry", "tvTopBarTitle is not an instance of TextView");
        }
        findViewById(R.id.viewpager).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent();
                intent.setClass(FragmentEntryActivity.this, ViewPagerFragmentActivity.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
                startActivity(intent);
            }
        });

        findViewById(R.id.fragmentmanager).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent();
                intent.setClass(FragmentEntryActivity.this, FragmentManagerActivity.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
                startActivity(intent);
            }
        });
    }
}
