/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

#ifndef BRIDGE_MANAGER_H
#define BRIDGE_MANAGER_H

#import <Foundation/Foundation.h>
#import "BridgeUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface BridgeManager : NSObject<IMessageListener, IMethodResult>

+ (instancetype)sharedInstance;
- (nullable BridgeUtil *)getBridgeWithName:(NSString *)name bridgeType:(BridgeType)bridgeType;

@end

NS_ASSUME_NONNULL_END

#endif /* BRIDGE_MANAGER_H */
