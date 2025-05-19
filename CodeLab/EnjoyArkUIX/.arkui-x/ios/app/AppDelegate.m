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

#import "AppDelegate.h"
#import "MainViewController.h"
#import "CenterViewController.h"
#import "MineViewController.h"
#import <libarkui_ios/StageApplication.h>


#define BUNDLE_DIRECTORY @"arkui-x"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [StageApplication configModuleWithBundleDirectory:BUNDLE_DIRECTORY];
    [StageApplication launchApplication];
    MainViewController *mainVC = [[MainViewController alloc] init];
    [self setTabItemNormalImg:@"firstPageIcon_N" selectImg:@"firstPageIcon_S" title:@"自测试" vcName:mainVC];
    CenterViewController *centerVC = [[CenterViewController alloc] init];
    [self setTabItemNormalImg:@"otherIcon_N" selectImg:@"otherIcon_S" title:@"演示" vcName:centerVC];
    MineViewController *mineVC = [[MineViewController alloc] init];
    [self setTabItemNormalImg:@"mineIcon_N" selectImg:@"mineIcon_S" title:@"版本" vcName:mineVC];
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:centerVC];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[mainNav, centerNav, mineNav];
    tabBarController.tabBar.barTintColor = [UIColor whiteColor];
    tabBarController.tabBar.tintColor = [UIColor systemBlueColor];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (_allowRotation) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setTabItemNormalImg:(NSString *)normalImg selectImg:(NSString *)selectImg title:(NSString *)title vcName:(UIViewController *)vcName {
    vcName.tabBarItem.image = [UIImage imageNamed:normalImg];
    vcName.tabBarItem.selectedImage = [UIImage imageNamed:selectImg];
    vcName.tabBarItem.title = title;
    vcName.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
