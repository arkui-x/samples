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

import CommonConstants from '../common/constants/CommonConstants';

/**
 * 商品类
 */
@Observed
export class Product {
  id: string = '';
  type: string = '';
  logo: string = '';
  title: string = '';
  discount: string = '';
  price: number = 0;
  sales: string = '';
}

/**
 * 商品数据类，基于LazyForEach
 */
export class ProductsDataSource implements IDataSource{
  private productArr: Array<Product> = [];

  constructor() {
    this.productArr = getProductInfoMock();
  }

  totalCount(): number {
    return this.productArr.length;
  }

  getData(index: number): Product {
    return this.productArr[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
  }
}

/**
 * 商品数据mock接口
 * @returns 商品数据列表
 */
function getProductInfoMock(): Array<Product> {
  const productArr: Array<Product> = [];
  CommonConstants.PRODUCT_DATA_ARR_MOCK.forEach(( mockData: ESObject, index: number ) => {
    const product = new Product();
    product.id = (Math.random() * 1000).toString();
    product.type = mockData[0] as string;
    product.logo = `app.media.imageresizable_product${index + 1}`;
    product.title = mockData[1] as string;
    product.discount = mockData[2] as string;
    product.price = mockData[3] as number;
    product.sales = mockData[4] as string;
    productArr.push(product);
  })

  return productArr;
}
