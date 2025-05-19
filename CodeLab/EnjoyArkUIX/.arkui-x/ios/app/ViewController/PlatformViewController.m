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
 
#import "PlatformViewController.h"
#import "ArkBridgeClass.h"
#import <libarkui_ios/StageApplication.h>
#import <libarkui_ios/BridgePlugin.h>
#import "MyPlatformViewFactory.h"

@interface PlatformViewController ()

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) StageViewController *stageVC;
@property (nonatomic, assign) CGFloat statusBarHeight;

@end

@implementation PlatformViewController {
    NSObject<PlatformViewFactory> *factory;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.statusBarHeight = 0;
    factory = [MyPlatformViewFactory alloc];
    [super registerPlatformViewFactory:factory];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}
@end
