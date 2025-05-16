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

package com.example.enjoyarkuix.bean;

import java.io.Serializable;

/**
 * ItemDataBean
 *
 * @since 20
 */
public class ItemDataBean implements Serializable {
    private String itemTitle;
    private int itemJudgeType;
    private String itemModuleName;
    private String itemAbilityName;
    private int nPage;
    private Class clz;

    public ItemDataBean(String title, int judgeType, int page) {
        itemTitle = title;
        itemJudgeType = judgeType;
        nPage = page;
    }

    public ItemDataBean(String title, int judgeType, Class<?> aClass) {
        itemTitle = title;
        itemJudgeType = judgeType;
        clz = aClass;
    }

    public ItemDataBean(String title, int judgeType, String moduleName, String abilityName) {
        itemTitle = title;
        itemJudgeType = judgeType;
        itemModuleName = moduleName;
        itemAbilityName = abilityName;
    }

    public String getItemTitle() {
        return itemTitle;
    }

    public void setItemTitle(String itemTitle) {
        this.itemTitle = itemTitle;
    }

    public int getItemJudgeType() {
        return itemJudgeType;
    }

    public void setItemJudgeType(int itemJudgeType) {
        this.itemJudgeType = itemJudgeType;
    }

    public String getItemModuleName() {
        return itemModuleName;
    }

    public void setItemModuleName(String itemModuleName) {
        this.itemModuleName = itemModuleName;
    }

    public String getItemAbilityName() {
        return itemAbilityName;
    }

    public void setItemAbilityName(String itemAbilityName) {
        this.itemAbilityName = itemAbilityName;
    }

    public int getPage() {
        return nPage;
    }

    public void setPage(int page) {
        this.nPage = page;
    }

    public Class getClz() {
        return clz;
    }

    public void setClz(Class clz) {
        this.clz = clz;
    }
}