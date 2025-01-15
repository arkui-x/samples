/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { mapCommon } from '@kit.MapKit';

export class MapElement {
  id: number = 0;
  tag: string = '';
  title: Resource = $r('app.string.name_f');
  zone: Resource = $r('app.media.img_placeholder');
  icon: ResourceStr = '';
  textColor: number = 0xFF00000;
  position: mapCommon.LatLng = {
    latitude: 22.874712,
    longitude: 113.880028
  };
}

export const mapElementData: MapElement[] = [
  {
    id: 0,
    tag: 'F',
    title: $r('app.string.name_f'),
    zone: $r('app.string.area_name_f'),
    icon: $r('app.media.icon_f'),
    textColor: 0xFFFA9855,
    position: { longitude: 113.887634, latitude: 22.875929 }
  },
  {
    id: 1,
    tag: 'G',
    title: $r('app.string.name_g'),
    zone: $r('app.string.area_name_g'),
    icon: $r('app.media.icon_g'),
    textColor: 0xFF2F6BFF,
    position: { longitude: 113.890251, latitude: 22.877352 }
  },
  {
    id: 2,
    tag: 'H',
    title: $r('app.string.name_h'),
    zone: $r('app.string.area_name_h'),
    icon: $r('app.media.icon_h'),
    textColor: 0xFF2F6BFF,
    position: { longitude: 113.890488, latitude: 22.880936 }
  },
  {
    id: 3,
    tag: 'J',
    title: $r('app.string.name_j'),
    zone: $r('app.string.area_name_j'),
    icon: $r('app.media.icon_j'),
    textColor: 0xFF2F6BFF,
    position: { longitude: 113.889091, latitude: 22.883272 }
  },
  {
    id: 4,
    tag: 'K',
    title: $r('app.string.name_k'),
    zone: $r('app.string.area_name_k'),
    icon: $r('app.media.icon_k'),
    textColor: 0xFFFA9855,
    position: { longitude: 113.88549, latitude: 22.881063 }
  },
  {
    id: 5,
    tag: 'L',
    title: $r('app.string.name_l'),
    zone: $r('app.string.area_name_l'),
    icon: $r('app.media.icon_l'),
    textColor: 0xFFE84026,
    position: { longitude: 113.886642, latitude: 22.878538 }
  }
];