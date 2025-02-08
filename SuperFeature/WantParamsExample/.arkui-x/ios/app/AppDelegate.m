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
#import "EntryEntryAbilityViewController.h"

#import <libarkui_ios/StageApplication.h>
#import <libarkui_ios/WantParams.h>
#import "WantViewController.h"

#define BUNDLE_DIRECTORY @"arkui-x"
#define BUNDLE_NAME @"com.example.wantparams"



@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [StageApplication configModuleWithBundleDirectory:BUNDLE_DIRECTORY];
    [StageApplication launchApplication];
    
    [self copyFilesToDocumentsDirectory];
    NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",BUNDLE_NAME, @"entry", @"EntryAbility"];
    EntryEntryAbilityViewController *mainView = [[EntryEntryAbilityViewController alloc] initWithInstanceName:instanceName];
    
    NSNumber *numberYes = [NSNumber numberWithBool:true];
    //NSNumber *numberNo = [NSNumber numberWithBool:false];
    
    NSNumber *numberInt = [NSNumber numberWithInt:12];
    
    NSNumber *numberDouble = [NSNumber numberWithDouble:1.1415926];
    
    WantParams *wp = [[WantParams alloc]init];
    [wp addValue:@"strkey" value:@"strWantParams"];
    
    NSArray *arr = @[@(123) , @(1) , @(2)];
    
    
    WantParams *params = [[WantParams alloc]init];
    [params addValue:@"boolKey" value:numberYes];
    [params addValue:@"intKey" value:numberInt];
    [params addValue:@"doubleKey" value:numberDouble];
    [params addValue:@"stringKey" value:@"strArkui"];
    [params addValue:@"wantParamsKey" value:wp];
    [params addValue:@"arrayKey" value:arr];

    mainView.params = [params toWantParamsString];
    [self setNavRootVC:mainView];
    
    return YES;
}

- (void)copyFilesToDocumentsDirectory {
    NSString *sourceFolderName = @"second"; // 指定文件夹名称
    //    NSString *sourceFolderPath = [[NSBundle mainBundle] pathForResource:@"second" ofType:@"html"];    // 获取源文件夹路径
    NSString *sourceFolderPath = [[NSBundle mainBundle] pathForResource:sourceFolderName ofType:@"html"];
    
    // 沙盒目标文件夹路径
    NSString *destinationFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"files"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    if (![fileManager fileExistsAtPath:sourceFolderPath]) {
        NSLog(@"Files doc does not exist.");
        return;
    }
    
    // 删除目标文件夹
    if ([fileManager fileExistsAtPath:destinationFolderPath]) {
        if (![fileManager removeItemAtPath:destinationFolderPath error:&error]) {
            NSLog(@"Error removing directory: %@", error);
            return;
        }
    }
    
    // 创建目标文件夹
    if (![fileManager fileExistsAtPath:destinationFolderPath]) {
        [fileManager createDirectoryAtPath:destinationFolderPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"Error creating directory: %@", error);
            return;
        }
    }
    
    NSString *fileName = @"second.html";
    
    NSString *sourceFilePath = sourceFolderPath;
    NSString *destinationFilePath = @"";
    if (fileName) {
        destinationFilePath = [destinationFolderPath stringByAppendingPathComponent: fileName];
    }
    
    [fileManager copyItemAtPath:sourceFilePath toPath:destinationFilePath error:&error];
    if (error) {
        NSLog(@"Error copying file %@: %@", fileName, error);
    }
    NSLog(@"Files copied successfully.");
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    NSLog(@"appdelegate openUrl callback, url : %@", url.absoluteString); // eg: (com.entry.arkui://entry?OtherAbility)
    
    NSString *bundleName = url.scheme;
    NSString *moduleName = url.host;
    NSString *abilityName, *params;
    
    NSURLComponents * urlComponents = [NSURLComponents componentsWithString:url.absoluteString];
    NSArray <NSURLQueryItem *> *array = urlComponents.queryItems;
    for (NSURLQueryItem * item in array) {
        if ([item.name isEqualToString:@"abilityName"]) {
            abilityName = item.value;
        } else if ([item.name isEqualToString:@"params"]) {
            params = item.value;
        }
    }
    UINavigationController *rootNav = (UINavigationController *)self.window.rootViewController;
    EntryEntryAbilityViewController *rootVc = (EntryEntryAbilityViewController *)rootNav.viewControllers.firstObject;
    WantViewController *vc = [[WantViewController alloc]init];
    vc.strParams = params;
    [rootNav pushViewController:vc animated:YES];
    return YES;
}


- (void)setNavRootVC:(id)viewController {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self setNaviAppearance:navi];
    self.window.rootViewController = navi;
    
}

- (void)setNaviAppearance:(UINavigationController *)navi {
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = UIColor.whiteColor;
        navi.navigationBar.standardAppearance = appearance;
        navi.navigationBar.scrollEdgeAppearance = navi.navigationBar.standardAppearance;
    } else {
        // Fallback on earlier versions
    }
    
}


@end
