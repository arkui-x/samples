/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

/**
 * 通用常量
 */
export default class CommonConstants {
  /**
   * 商品mock数据
   */
  static readonly PRODUCT_DATA_ARR_MOCK = [
    ['1', '商品A', '200减30券', 200, '537'],
    ['2', '商品B', '8折促销', 18999, '500'],
    ['3', '商品C', '20元无门槛券', 3500, '2000+'],
    ['4', '商品D', '满5000减50', 39999, '9999'],
    ['5', '商品E', '2件减20', 249, '5000+'],
    ['3', '商品F', '任选3件85折', 3499, '3000+'],
    ['3', '商品G', '第二件半价', 5000, '787'],
    ['3', '商品H', '跨店每满400减100', 6999, '238'],
    ['3', '商品I', '3期免息券', 7899, '1000+'],
    ['3', '商品J', '多买优惠', 5999, '845'],
    ['3', '商品K', '店铺满3000减60', 6799, '2500+'],
    ['3', '商品L', '官方立减5.8元', 3499, '367'],
    ['3', '商品M', '赠运费险', 6500, '1500+'],
    ['3', '商品N', '首单直降3元', 8999, '50']
  ];

  /**
   * 首页瀑布流列项布局模版
   */
  static readonly MAIN_PAGE_WATERFLOW_COLUMNS_TEMPLATE = '1fr 1fr';

  /**
   * 商品销量文案
   */
  static readonly PRODUCT_SALE_TEXT = '销量';

  /**
   * 商品销量描述最大行数
   */
  static readonly PRODUCT_SALE_MAX_LINES = 1;
}

