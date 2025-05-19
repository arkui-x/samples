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

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import com.example.enjoyarkuix.bean.ItemDataBean;
import com.example.enjoyarkuix.databinding.FragmentItemBinding;
import com.example.enjoyarkuix.interfaces.OnItemClickListener;

import java.util.ArrayList;

/**
 * MyItemRecyclerViewAdapter
 *
 * @since 20
 */

public class MyItemRecyclerViewAdapter extends RecyclerView.Adapter<MyItemRecyclerViewAdapter.ViewHolder> {
    private OnItemClickListener mOnItemClickListener;
    private final ArrayList<ItemDataBean> mValues;

    public MyItemRecyclerViewAdapter(ArrayList<ItemDataBean> items) {
        mValues = items;
    }

    public void setOnItemClickListener(OnItemClickListener onItemClickListener) {
        mOnItemClickListener = onItemClickListener;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        return new ViewHolder(FragmentItemBinding.inflate(LayoutInflater.from(parent.getContext()), parent, false));
    }

    @Override
    public void onBindViewHolder(final ViewHolder holder, int position) {
        ItemDataBean itemDataBean = mValues.get(position);
        holder.mContentView.setText(itemDataBean.getItemTitle());
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mOnItemClickListener != null) {
                    mOnItemClickListener.onItemClick(v, position);
                }
            }
        });
    }

    @Override
    public int getItemCount() {
        return mValues.size();
    }

    /**
     * ViewHolder
     *
     * @since 2025-05-12
     */
    public class ViewHolder extends RecyclerView.ViewHolder {
        /**
         * mContentView
         */
        public final TextView mContentView;

        public ViewHolder(FragmentItemBinding binding) {
            super(binding.getRoot());
            mContentView = binding.content;
        }

        @Override
        public String toString() {
            return super.toString() + " '" + mContentView.getText() + "'";
        }
    }
}