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


#import "MyDemo.h"
#import <Foundation/Foundation.h>
#import "IMapView.h"

@implementation MyDemo {
    MKMapView *mapView;
    NSString* viewTag;
}

- (instancetype)initWithFrame
{
    self = [super init];
    if (self) {
        viewTag = @"PlatformViewTest1";
        mapView = [[IMapView alloc] init];
        mapView.showsCompass = YES;
        mapView.showsScale = YES;
        [mapView setMapType:MKMapTypeStandard];
        mapView.showsUserLocation = YES;
    }
    return self;
}

- (UIView*) view {
    return mapView;
}

- (void) onDispose {
    mapView = nil;
}

- (NSString*) getXComponentID {
    return viewTag;
}

@end
