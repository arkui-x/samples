/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

#import "SecondFloorViewController.h"
#import "PhonePhoneAbilityViewController.h"
#import "AppDelegate.h"

@interface SecondFloorViewController ()
{
    PhonePhoneAbilityViewController *entryVC;
    UIView *mainView;
}

@end

@implementation SecondFloorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [self createUI];
    
    // 创建自定义滑动手势
        UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgePanGesture:)];
        edgePan.edges = UIRectEdgeLeft; // 从左边缘滑动
        [self.view addGestureRecognizer:edgePan];
    

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)handleEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"左滑返回手势结束");
        // 可以在这里实现页面返回操作
//        [self dismissViewControllerAnimated:YES completion:nil];
//        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [appDelegate backToNativeVC];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)createUI {
    CGFloat topHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    topHeight = 0;
    mainView = [[UIView alloc] init];
    mainView.frame = CGRectMake(0, topHeight, self.view.frame.size.width, self.view.frame.size.height - topHeight);
    [self.view addSubview:mainView];
    entryVC = [[PhonePhoneAbilityViewController alloc] initWithInstanceName:self.instanceName];
    entryVC.view.frame = CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height);
    entryVC.view.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:entryVC.view];
    [self addChildViewController:entryVC];
}

@end
