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

// 定义一个用户类
export class UserBookingInfo {
  userName: string = '张山'; // 姓名
  userID: string = '332045199008120045'; // 证件号
  date: string = '1月1日' // 日期
  seatNo: number = 0; // 座位号
  price: number = 200; // 价格
  constructor(name: string, id: string, date: string) {
    this.userName = name;
    this.userID = id;
    this.date = date;
  }

  // 获取随机座位号
  generateRandSeatNo(): number {
    this.seatNo = Math.floor(Math.random() * (200 - 1) + 1);  // 获取200以内随机号
    return this.seatNo;
  }
}