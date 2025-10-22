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

#import "BridgeManager.h"

@interface BridgeManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, BridgeUtil *> *bridgeMap;

@end

@implementation BridgeManager

+ (instancetype)sharedInstance {
    static BridgeManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BridgeManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _bridgeMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (nullable BridgeUtil *)getBridgeWithName:(NSString *)name bridgeType:(BridgeType)bridgeType {
    BridgeUtil *existingBridge = self.bridgeMap[name];
    if (existingBridge) {
        if (existingBridge.type == bridgeType) {
            return existingBridge;
        } else {
            NSLog(@"Bridge bridgeType incompatible");
            [existingBridge unRegister:name];
            [self.bridgeMap removeObjectForKey:name];
        }
    }

    BridgeUtil *newBridge = [[BridgeUtil alloc] initBridgePlugin:name bridgeType:bridgeType];
    if (newBridge) {
        self.bridgeMap[name] = newBridge;
    }
    return newBridge;
}

- (BOOL)removeBridgeWithName:(NSString *)name {
    if (!name) {
        NSLog(@"Invalid argument");
        return NO;
    }
    BridgeUtil *removedBridge = self.bridgeMap[name];
    if (removedBridge) {
        [self.bridgeMap removeObjectForKey:name];
        [removedBridge unRegister:name];
    }
    return removedBridge != nil;
}

@end
