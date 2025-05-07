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

import {
  BaseDanmaku,// 弹幕类
  BaseDanmakuParser, //弹幕控制类，设置时间、区域等
  DanmakuFactory, //弹幕参数类，如各个类型的弹幕存活时间
  Danmakus, //重写IDanmakus
  DanmakuUtils, //设置弹幕是否允许碰撞、检测弹幕碰撞、对比弹幕、检测是否重复
  Duration, //弹幕持续时间
  IDanmakus, //弹幕管理，如增删
  IDisplayer, //获取弹幕信息、设置弹幕
  SpecialDanmaku, //特殊弹幕类
  ST_BY_TIME //弹幕开始时间类型
} from '@ohos/danmakuflamemaster';

/*
 * 弹幕解析类，提供解析弹幕数据方法以及弹幕展示方法，可根据弹幕的mock数据解析出每一条弹幕的样式、开始/结束位置、持续时间等
 */
export class DanmakuParser extends BaseDanmakuParser {
  protected dispScaleX: number = 0;
  protected dispScaleY: number = 0;

  parse(): IDanmakus | ESObject {
    class danmakus {
      sortType: number = 0;
      duplicateMergingEnabled: boolean = false;
      baseComparator: ESObject;
    }

    if (this.mDataSource === null) {
      return;
    }
    let args: danmakus = {
      sortType: ST_BY_TIME,
      duplicateMergingEnabled: false,
      baseComparator: this.mContext.getBaseComparator()
    };
    let result: Danmakus = new Danmakus((args));
    this.mDataSource.data().forEach((sourceItem: ESObject) => {
      // 根据弹幕的类型和上下文信息创建一条弹幕数据
      let item: SpecialDanmaku = this.mContext.mDanmakuFactory.createDanmakuByContext(Number(sourceItem.DanmakuType), this.mContext);
      if(item !== null){
        item.setTime(Number.parseFloat(sourceItem.time));
        const textBaseSize = getContext(this).resourceManager.getNumber($r("app.float.danmaku_player_time_text_base_size"))
        const baseDispDensity = getContext(this).resourceManager.getNumber($r("app.float.danmaku_player_time_base_disp_density"))
        item.textSize = textBaseSize * Number.parseFloat(sourceItem.textSize) * (this.mDispDensity * 0.8);
        item.textColor = Number(sourceItem.textColor);
        item.textShadowColor = Number(sourceItem.textShadowColor);
        item.text = sourceItem.text;
        item.index = Number(sourceItem.index);
        DanmakuUtils.fillText(item, item.text);
        if (Number(sourceItem.DanmakuType) === BaseDanmaku.TYPE_SPECIAL) {
          item.duration = new Duration(Number.parseFloat(sourceItem.duration));
          item.rotationZ = Number.parseFloat(sourceItem.rotationZ);
          item.rotationY = Number.parseFloat(sourceItem.rotationY);
          this.mContext.mDanmakuFactory.fillTranslationData(item,
            Number.parseFloat(sourceItem.beginX),
            Number.parseFloat(sourceItem.beginY),
            Number.parseFloat(sourceItem.endX),
            Number.parseFloat(sourceItem.endY),
            Number.parseFloat(sourceItem.translationDuration),
            Number.parseFloat(sourceItem.translationStartDelay),
            this.dispScaleX, this.dispScaleY);
          this.mContext.mDanmakuFactory.fillAlphaData(item,
            Number(sourceItem.beginAlpha),
            Number(sourceItem.endAlpha),
            Number.parseFloat(sourceItem.alphaDuration));
          (item as SpecialDanmaku).isQuadraticEaseOut = Boolean((sourceItem.isQuadraticEaseOut) as boolean);
        }
      }
      if (item.text !== null) {
        if (item.duration !== null) {
          item.setTimer(this.mTimer);
          item.flags = this.mContext.mGlobalFlagValues;
          result.addItem(item);
        }
      }
    })
    return result;
  }

  setDisplayer(disp: IDisplayer) {
    super.setDisplayer(disp);
    this.dispScaleX = this.mDispWidth / DanmakuFactory.BILI_PLAYER_WIDTH;
    this.dispScaleY = this.mDispHeight / DanmakuFactory.BILI_PLAYER_HEIGHT;
    return this;
  }
}