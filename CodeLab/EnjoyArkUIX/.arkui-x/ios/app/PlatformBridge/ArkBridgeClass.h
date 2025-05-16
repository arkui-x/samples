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

#ifndef ARKBRIDGECLASS_H
#define ARKBRIDGECLASS_H

#import <Foundation/Foundation.h>
#import <libarkui_ios/BridgePlugin.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArkBridgeClass : BridgePlugin<IMessageListener, IMethodResult>

- (NSString *)getHelloArkUI:(id)param;
- (NSString *)methodOfPlatform:(id)param;

@end

NS_ASSUME_NONNULL_END
 #endif