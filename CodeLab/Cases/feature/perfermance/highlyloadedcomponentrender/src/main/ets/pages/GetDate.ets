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
import { LunarDate, solar2lunar } from 'lunar_lite';

const SATURDAY: number = 6; // 日历表上周六对应的序列号，从周日开始算起，取值0~6
const LUNAR_STR: string = '初';

/*
 * 根据指定年份和月份获取该月在日历表上的日期排布数据
 * @param {number} specifiedMonth - 指定月份
 * @param {number} specifiedYear - 指定年份
 */
export function getMonthDate(specifiedMonth: number, specifiedYear: number): number[] {
  let currentFirstWeekDay: number = 0; // 初始化指定月的第一天是周几
  let currentLastWeekDay: number = 0; // 初始化指定月的最后一天是周几
  const currentAllDay: number[] = []; // 初始化指定月的日期排列数组
  const totalDays = new Date(specifiedYear, specifiedMonth, 0).getDate(); // 初始化指定月总天数
  currentFirstWeekDay = new Date(specifiedYear, specifiedMonth - 1, 1).getDay(); // 获取指定月的第一天是周几
  currentLastWeekDay = new Date(specifiedYear, specifiedMonth - 1, totalDays).getDay(); // 获取指定月的最后一天是周几
  // 将月份中显示上个月日期的内容置0
  for (let item = 0; item < currentFirstWeekDay; item++) {
    currentAllDay[item] = 0;
  }
  // 将本月日期内容存入数组
  for (let item = 1; item <= totalDays; item++) {
    currentAllDay.push(item);
  }
  // 将月份中显示下个月日期的内容置0
  for (let item = 0; item < SATURDAY - currentLastWeekDay; item++) {
    currentAllDay.push(0);
  }
  return currentAllDay;
}

export function dateToLunar(year: number, month: number, day: number): string {
  let lunarDate: LunarDate = solar2lunar(`${year}-${month}-${day}`);
  const dayStr: string[] = ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十'];
  let lunarDay: string = '';
  const numberDay: number = lunarDate.lunarDay;
  if (numberDay <= 10 && numberDay > 0) {
    lunarDay = LUNAR_STR + dayStr[numberDay-1];
  } else {
    const first =
      numberDay.toString().charAt(0) === '1' ? '十' : (numberDay.toString().charAt(0) === '2' ? '廿' : '三');

    const second =
      numberDay.toString().charAt(1) === '0' ? '十' : dayStr[Number.parseInt(numberDay.toString().charAt(1))-1];
    lunarDay = first + second;
  }
  return lunarDay;
}