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

declare namespace XcomponentNapi {
  export interface TouchEventInfo {
    surface_X: number;
    surface_Y: number;
    touchType: number;
    touchInfo: string;
  }

  export interface MouseEventInfo {
    surface_X1: number;
    surface_Y1: number;
    mousebutton: number;
    keyMouseEventInfo: string;
    isHover: boolean;
  }

  export interface KeyEventInfo {
    action: number;
    code: number;
    sourceType: number;
    timestamp: number;
    deviceId: number;
    keyEventInfo: string;
    keyEventGetInfo: string;
  }

  export interface XcomponentNapiObject {
    // @ts-ignore
    updateAngle:(offsetX:number, offsetY:number)=>Array;
    UpdateForceWithCallBack:()=>boolean;

    SetExpectedFrameRateRange:(max:number, min:number)=>boolean;
    BeginFrameRateCallback:()=>boolean;
    EndFrameRateCallback:()=>boolean;

    GetXComponentId:()=>String;

    GetXComponentSize_Width:()=>number;

    GetXComponentSize_Height:()=>number;

    GetXComponentOffset_x:()=>number;

    GetXComponentOffset_y:()=>number;

    GetXComponent_TouchEvent:()=>TouchEventInfo;

    GetXComponentpointtool_tiltx:()=>number;

    GetXComponentpointtool_tilty:()=>number;

    GetXComponentpointtool_type:()=>number;

    GetXComponent_MouseEvent:()=>MouseEventInfo;

    GetXComponent_GetKeyEvent:()=>KeyEventInfo;
  }
}