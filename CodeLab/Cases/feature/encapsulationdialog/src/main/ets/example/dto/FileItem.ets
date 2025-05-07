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

@Observed
export class FileItem {
  name: string = '';
  type: FileType = FileType.UN_KNOWN;
  icon: Resource = $r("app.media.encapsulation_dialog_png");
  size: string = (Math.random() * 10).toFixed(1) + 'MB';
  time: string = Date.now().toString();
  isSelected: boolean = false;
  bottomHeight: number = 0;
  screenHeight: number = 0;

  constructor(name: string, type?: FileType) {
    if (type === undefined) {
      this.initOnlyName(name);
    } else {
      this.initByNameAndType(name, type);
    }
  }

  private initByNameAndType(name: string, type: FileType) {
    this.name = name;
    this.type = type;
    switch (type) {
      case FileType.WORD:
        this.icon = $r("app.media.encapsulation_dialog_word");
        break;
      case FileType.IMAGE:
        this.icon = $r("app.media.encapsulation_dialog_png");
        break;
      case FileType.EXCEL:
        this.icon = $r("app.media.encapsulation_dialog_excel");
        break;
      case FileType.PPT:
        this.icon = $r("app.media.encapsulation_dialog_ppt");
        break;
      default:
        this.icon = $r("app.media.encapsulation_dialog_png");
        break;
    }
  }

  private initOnlyName(name: string) {
    this.name = name;
    let arr: string[] = name.split('.');
    switch (arr[arr.length - 1]) {
      case FileNameSuffix.WORD:
        this.type = FileType.WORD;
        this.icon = $r("app.media.encapsulation_dialog_word");
        break;
      case FileNameSuffix.PPT:
        this.type = FileType.PPT;
        this.icon = $r("app.media.encapsulation_dialog_ppt");
        break;
      case FileNameSuffix.EXCEL:
        this.type = FileType.EXCEL;
        this.icon = $r("app.media.encapsulation_dialog_excel");
        break;
      case FileNameSuffix.IMAGE:
        this.type = FileType.IMAGE;
        this.icon = $r("app.media.encapsulation_dialog_png");
        break;
      default:
        this.type = FileType.UN_KNOWN;
        this.icon = $r("app.media.encapsulation_dialog_png");
        break;
    }
  }

  equal(item: FileItem): boolean {
    if (this.name === item.name && this.type === item.type && this.size === item.size && this.time === item.time) {
      return true;
    }
    return false;
  }
}

export enum FileType {
  UN_KNOWN = 'UN_KNOWN',
  PPT = 'ppt',
  WORD = 'word',
  IMAGE = 'image',
  EXCEL = 'excel'
}

enum FileNameSuffix {
  WORD = 'doc',
  PPT = 'ppt',
  IMAGE = 'png',
  EXCEL = 'xls'
}