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
import { AttributeSet } from "./AttributeSet";
import { Offset } from "./Offset";
import { ToolInterface } from "./ToolInterface";

/**
 * 自定义工具项
 *
 */
export class CustomTool {
  // 工具项UI
  private builder_: WrappedBuilder<[ToolInterface]>;
  // 工具项相对于悬浮球中心的偏移
  private offset_: Offset;
  // 悬浮球位于角落时工具项相对于悬浮球中心的偏移
  private cornerOffset_: Offset;
  // 工具项属性集
  private attributeSet_?: AttributeSet;

  constructor(builder: WrappedBuilder<[ToolInterface]>, offset: Offset, cornerOffset: Offset,attributeSet?: AttributeSet) {
    this.builder_ = builder;
    this.offset_ = offset;
    this.cornerOffset_ = cornerOffset;
    this.attributeSet_ = attributeSet;
  }

  get builder(): WrappedBuilder<[ToolInterface]> {
    return this.builder_;
  }

  get offset(): Offset {
    return this.offset_;
  }

  get cornerOffset(): Offset {
    return this.cornerOffset_;
  }

  get attributeSet(): AttributeSet | undefined {
    return this.attributeSet_;
  }
}