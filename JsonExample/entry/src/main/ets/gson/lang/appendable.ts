/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

export class Appendable {
  private str: string;

  constructor(str?: string | boolean | number) {
    if (str == null) {
      this.str = null;
    } else if (typeof str !== 'string') {
      this.str = str.toString();
    } else {
      this.str = str;
    }
  }

  public append(s: string | boolean | number): Appendable{
    if (s == null) {
      s = 'null';
    }
    if (typeof s !== 'string') {
      s = s.toString();
    }
    if (this.str == null) {
      this.str = s;
    } else {
      this.str += s;
    }
    return this;
  }

  public appendWithStartAndEnd(s: string, start: number, end: number) {
    if (s == null) {
      s = 'null';
    }
    if (this.str == null) {
      this.str = s;
    } else {
      if (this.checkRange(start, end, s.length)) {
        this.str += s.substring(start, end);
      }
    }
    return this;
  }

  public toString(): string{
    if (this.str == null) {
      this.str = 'null';
    }
    return this.str;
  }

  public length(): number{
    if (this.str == null) {
      this.str = 'null';
    }
    return this.str.length;
  }

  public setLength(newLength: number) {
    if (this.str == null) {
      this.str = 'null';
    }
    if (newLength < 0 || newLength >= this.str.length) {
      return;
    }
    this.str.substring(0, newLength);
  }

  private checkRange(start: number, end: number, len: number): boolean {
    if (start < 0 || start > end || end > len) {
      return false;
    }
    return true;
  }
}