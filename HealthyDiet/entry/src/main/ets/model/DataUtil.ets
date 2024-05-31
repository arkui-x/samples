/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import router from '@ohos.router'
import {
  FoodInfo,
  Category,
  CategoryId,
  MealTimeId,
  OneMealStatisticsInfo,
  MealFoodInfo,
  DietRecord,
  MealTime
} from './DataModels'
import { mockFoods, mockFoodInfo, mockDietRecords } from '../mock/MockData'

const DEBUG_PREVIEW = false
const MOCK_API = true

export function getFoods(): Array<FoodInfo> {
  return mockFoods
}

export function getFoodInfo(): FoodInfo {
  const params = router.getParams() as Record<string, Object>
  return DEBUG_PREVIEW ? mockFoodInfo : (params.foodId as FoodInfo)
}

// make records ordered by meal time
export let initDietRecords: Array<DietRecord> = [
  new DietRecord(-1, 0, new MealTime(MealTimeId.Breakfast), 0, '1'),
  new DietRecord(-1, 0, new MealTime(MealTimeId.Lunch), 0, '2'),
  new DietRecord(-1, 0, new MealTime(MealTimeId.Dinner), 0, '3'),
  new DietRecord(-1, 0, new MealTime(MealTimeId.Supper), 0, '4')
]

export function getDietRecords(): Array<DietRecord> {
  return DEBUG_PREVIEW ? initDietRecords.concat(mockDietRecords) :
  AppStorage.Get<Array<DietRecord>>('dietRecords') as Array<DietRecord>
}

export function getFoodCategories(): Category[] {
  return [{ id: CategoryId.Vegetable, name: $r('app.string.category_vegetable') },
    { id: CategoryId.Fruit, name: $r('app.string.category_fruit') },
    { id: CategoryId.Nut, name: $r('app.string.category_nut') },
    { id: CategoryId.Seafood, name: $r('app.string.category_seafood') },
    { id: CategoryId.Dessert, name: $r('app.string.category_dessert') }]
}

export function getMileTimes(): string[] {
  if (MOCK_API) {
    return ['早餐', '午餐', '晚餐', '夜宵']
  } else {
    let mealTimeResources: Resource[] = [$r("app.string.meal_time_breakfast"), $r('app.string.meal_time_lunch'), $r('app.string.meal_time_dinner'), $r('app.string.meal_time_supper'), $r('app.string.category_dessert')]
    let mealTimes: string[] = []
    mealTimeResources.forEach(item => {
      let mealTime: string = getContext().resourceManager.getStringSync(item)
      if (mealTime !== '') {
        mealTimes.push(mealTime)
      }
    })
    return mealTimes
  }
}

export function getSortedFoodData(): Array<FoodInfo | string> {
  let letterReg: RegExp = new RegExp("^[A-Z]$");
  let list: Array<FoodInfo[]> = new Array<FoodInfo[]>();
  let foods: Array<FoodInfo> = getFoods();
  let letterArr: Array<string> = [];
  for (let i = 0; i < foods.length; i++) {
    list['#'] = new Array<FoodInfo>()
    // convert the first letter to uppercase
    let letter: string = foods[i].letter.substr(0, 1).toUpperCase()
    if (!letterReg.test(letter)) {
      letter = '#'
    }
    // create group by letter
    if (!(list[letter] != undefined)) {
      list[letter] = new Array<FoodInfo>()
      letterArr.push(letter)
    }
    list[letter].push(foods[i])
  }
  // sort by alphabetical order
  let letterGroup: Array<Record<string, string | Array<FoodInfo>>> = []
  for (let i = 0; i < letterArr.length; i++) {
      letterGroup.push({
        'letter': letterArr[i],
        'list': list[letterArr[i]]
      })
  }
  // console.log('zhengchao 1')
  letterGroup.sort((x, y) => {
    return String(x.letter).charCodeAt(0) - String(y.letter).charCodeAt(0);
  })
  // create result list
  let resultList: Array<FoodInfo | string> = [];
  for (let i = 0; i < letterGroup.length; i++) {
    resultList.push(letterGroup[i].letter as string)
    resultList = resultList.concat(letterGroup[i].list)
  }
  return resultList
}

export function statistics(): Array<OneMealStatisticsInfo> {
  console.info('meal statistics')
  let dietRecords = getDietRecords()
  let mealMap: Map<MealTimeId, OneMealStatisticsInfo> = new Map()
  dietRecords.forEach((item: DietRecord) => {
    if (item.mealTime != null) {
      let oneMealStatisticsInfo: OneMealStatisticsInfo | undefined = mealMap.get(item.mealTime.id)
      if (oneMealStatisticsInfo === undefined) {
        oneMealStatisticsInfo = new OneMealStatisticsInfo(item.mealTime)
      }
      let foodInfo: FoodInfo | undefined = getFoods().find((food) => {
        return food.id === item.foodId
      })
      if (foodInfo === undefined) {
        return;
      }
      let calories = foodInfo.calories * item.weight
      let protein = foodInfo.protein * item.weight
      let fat = foodInfo.fat * item.weight
      let carbohydrates = foodInfo.carbohydrates * item.weight
      oneMealStatisticsInfo.mealFoods.push(new MealFoodInfo(item.id, foodInfo.name, foodInfo.image, calories,
        protein, fat, carbohydrates, item.weight, item.key))
      oneMealStatisticsInfo.totalFat += fat
      oneMealStatisticsInfo.totalCalories += calories
      oneMealStatisticsInfo.totalCarbohydrates += carbohydrates
      oneMealStatisticsInfo.totalProtein += protein
      oneMealStatisticsInfo.key = item.key
      mealMap.set(item.mealTime.id, oneMealStatisticsInfo)
    }
  }
)

  return Array.from(mealMap.values())
}

export function updateDietWeight(recordId: number, weight: number) {
  let dietRecords = getDietRecords()
  let index = dietRecords.findIndex((record) => {
    return record.id === recordId
  })
  dietRecords[index].weight = weight
  AppStorage.SetOrCreate<Array<DietRecord>>('dietRecords', dietRecords)
}