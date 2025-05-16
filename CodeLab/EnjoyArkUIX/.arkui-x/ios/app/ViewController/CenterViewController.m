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
 
#import "CenterViewController.h"
#import "MainTableViewCell.h"
#import "BaseModuleViewController.h"
#import "PlatformViewController.h"
#import "PublicAlertView.h"
#import "PlatformBridgeController.h"
#import "DynamicLoadViewController.h"

#define CELL_HEIGHT  80

static NSString *const CELL = @"CenterTableViewCell";

@interface CenterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) PublicAlertView *publicAlertView;

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:CELL];
    [self.view addSubview:self.publicAlertView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;
    [self setNewOrientation:NO];
}

- (void)setIsPortrait:(BOOL)isPortrait {
    if (!self.mainTableView) {
        return;
    }
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    if ((isPortrait && height < width) || (!isPortrait && width < height)) {
        width = self.view.frame.size.height;
        height = self.view.frame.size.width;
    }
    if (self.mainTableView.frame.size.width == width) {
        return;
    }
    self.mainTableView.frame = self.view.frame;
    [self.mainTableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL forIndexPath:indexPath];
    if (!cell) {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL];
    }
    cell.titleName = self.dataArray[indexPath.row];
    cell.publicWidth = self.view.frame.size.width;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleName = self.dataArray[indexPath.row];
    switch (indexPath.row) {
        case 0: {
            NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@", @"com.example.enjoyarkuix", @"PlatformBridge", @"PlatformBridgeAbility"];
            PlatformBridgeController *moduleVC = [[PlatformBridgeController alloc] init];
            moduleVC.titleName = titleName;
            moduleVC.hidesBottomBarWhenPushed = YES;
            moduleVC.instanceName = instanceName;
            moduleVC.isShowNavigationBar = YES;
            [self.navigationController pushViewController:moduleVC animated:YES];
            break;
        }
        default:
            break;
    }
}

- (PublicAlertView *)publicAlertView {
    if (!_publicAlertView) {
        _publicAlertView = [[PublicAlertView alloc] initWithFrame:self.view.frame mainTitle:@"待开发中……"];
    }
    return _publicAlertView;
}

- (NSArray *)dataArray {
    return @[@"PlatformBridge"];
}
@end
