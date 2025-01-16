/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
 * Music information entity class.
 */
export class SongItem {
  /**
   * Primary key ID.
   */
  id: number = 0;
  /**
   * Music name.
   */
  title: string = '';
  /**
   * Music author name.
   */
  singer: string = '';
  /**
   * Music logo information.
   */
  mark: Resource = $r('app.string.page_show');
  /**
   * Music avatar information.
   */
  label: Resource = $r('app.string.page_show');
  /**
   * Music file path information.
   */
  src: string = '';
  /**
   * Index of the current music list.
   */
  index: number = 0;
  /**
   * Lyric file path information.
   */
  lyric: string = '';
}
