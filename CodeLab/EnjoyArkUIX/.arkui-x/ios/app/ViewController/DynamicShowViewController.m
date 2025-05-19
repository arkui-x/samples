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
 
#import "DynamicShowViewController.h"
#import <Photos/Photos.h>
#import <libarkui_ios/StageApplication.h>
#import <libarkui_ios/BridgePlugin.h>
#import "PublicAlertView.h"


@interface DynamicShowViewController ()

@property (nonatomic, strong) StageApplication *application;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) StageViewController *stageVC;
@property (nonatomic, assign) CGFloat statusBarHeight;

@property (nonatomic, strong) UIImage *needEffectImage;
@property (nonatomic, strong) PublicAlertView *publicAlertView;

@property (nonatomic, strong) NSMutableArray *inputResultArray;

@end

@implementation DynamicShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}

- (void)createUI {
    self.mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mainView];
    self.stageVC = [[StageViewController alloc] initWithInstanceName:[NSString stringWithFormat:@"%@:%@:%@",
                                                                      BUNDLE_NAME, self.moduleName, self.abilityName]];
    self.stageVC.view.frame = CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height);
    self.stageVC.view.backgroundColor = [UIColor whiteColor];
    [self.mainView addSubview:self.stageVC.view];
}
@end
