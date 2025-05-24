/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
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
 
#import <Foundation/Foundation.h>
#import "MyPlatformViewFactory.h"
#import "MyWebview.h"
#import "MyMapView.h"
#import "MyVideoView.h"

@implementation MyPlatformViewFactory {

}

- (instancetype)initWithFrame{
    return self;
}

- (NSObject<IPlatformView>*)getPlatformView:(NSString*)xComponentId {
    NSLog(@"[PlatformViewUI] getPlatfformView");
    if ([xComponentId isEqualToString:@"WebView"]) {
        NSObject<IPlatformView> * view = [[MyWebview alloc] initWithFrame];
        return view;
    } else if ([xComponentId isEqualToString:@"MapView"]) {
        NSObject<IPlatformView> * view = [[MyMapView alloc] initWithFrame];
        return view;
    } else if ([xComponentId isEqualToString:@"VideoView"]) {
        NSObject<IPlatformView> * view = [[MyVideoView alloc] initWithFrame];
        return view;
    }
    return nil;
}
@end
