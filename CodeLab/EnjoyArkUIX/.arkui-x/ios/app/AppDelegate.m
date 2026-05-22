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

#import "AppDelegate.h"
#import "EntryEntryAbilityViewController.h"
#import "PlatformViewPlatformViewAbilityViewController.h"
#import "PlatformBridgePlatformBridgeAbilityViewController.h"
#import "DynamizationJumpController.h"
#import "TestTestAbilityViewController.h"
#import "VersionVersionAbilityViewController.h"
#import "ModifierModifierAbilityViewController.h"
#import "VideoPlayDemoVideoPlayDemoAbilityViewController.h"
#import "FileApiFileApiAbilityViewController.h"
#import "DrawingDrawingAbilityViewController.h"
#import "WindowWindowAbilityViewController.h"
#import "RDBDemoRDBDemoAbilityViewController.h"
#import "UDMFDemoUDMFDemoAbilityViewController.h"
#import "PreferencesDemoPreferencesDemoAbilityViewController.h"
#import "RequestDemoRequestDemoAbilityViewController.h"
#import "GeoLocationManagerDemoGeoLocationManagerDemoAbilityViewController.h"
#import "VibrationBasicDemoVibrationBasicDemoAbilityViewController.h"
#import "VibratorCustomHapticDemoVibratorCustomHapticDemoAbilityViewController.h"
#import "VibratorJsSamplesDemoVibratorJsSamplesDemoAbilityViewController.h"
#import "TaskPoolDemoTaskPoolDemoAbilityViewController.h"
#import "CollectionsDemoCollectionsDemoAbilityViewController.h"
#import "FastBufferDemoFastBufferDemoAbilityViewController.h"
#import "UtilsDemoUtilsDemoAbilityViewController.h"
#import "ImageDemoImageDemoAbilityViewController.h"
#import "I18nDemoI18nDemoAbilityViewController.h"
#import "HyperlinkDemoHyperlinkDemoAbilityViewController.h"
#import "GraphicsTextDemoGraphicsTextDemoAbilityViewController.h"
#import <libarkui_ios/StageApplication.h>

#define BUNDLE_DIRECTORY @"arkui-x"
#define BUNDLE_NAME @"com.example.enjoyarkuix"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [StageApplication configModuleWithBundleDirectory:BUNDLE_DIRECTORY];
    [StageApplication launchApplication];
    
    NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",BUNDLE_NAME, @"entry", @"EntryAbility"];
    EntryEntryAbilityViewController *mainView = [[EntryEntryAbilityViewController alloc] initWithInstanceName:instanceName];
    [self setNavRootVC:mainView];
    return YES;
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

    [self handleOpenUrlWithBundleName:bundleName
                           moduleName:moduleName
                          abilityName:abilityName
                               params:params, nil];
    
    return YES;
}

- (BOOL)handleOpenUrlWithBundleName:(NSString *)bundleName
                         moduleName:(NSString *)moduleName
                        abilityName:(NSString *)abilityName
                             params:(NSString *)params, ...NS_REQUIRES_NIL_TERMINATION {
    
    id rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    BOOL hasRoot = NO;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        hasRoot = YES;
    }
    
    id subStageVC = nil;
    
    if ([moduleName isEqualToString:@"entry"] && [abilityName isEqualToString:@"EntryAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        EntryEntryAbilityViewController *entryOtherVC = [[EntryEntryAbilityViewController alloc] initWithInstanceName:instanceName];
        entryOtherVC.params = params;
        subStageVC = (EntryEntryAbilityViewController *)entryOtherVC;
    } else if ([moduleName isEqualToString:@"PlatformView"] && [abilityName isEqualToString:@"PlatformViewAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        PlatformViewPlatformViewAbilityViewController *otherVC = [[PlatformViewPlatformViewAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (PlatformViewPlatformViewAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"PlatformBridge"] && [abilityName isEqualToString:@"PlatformBridgeAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        PlatformBridgePlatformBridgeAbilityViewController *otherVC = [[PlatformBridgePlatformBridgeAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (PlatformBridgePlatformBridgeAbilityViewController *)otherVC;
    }  else if ([moduleName isEqualToString:@"Dynamization"] && [abilityName isEqualToString:@"Jump"]) {
        subStageVC = [[DynamizationJumpController alloc] init];
    }else if ([moduleName isEqualToString:@"Test"] && [abilityName isEqualToString:@"TestAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        TestTestAbilityViewController *otherVC = [[TestTestAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (TestTestAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"version"] && [abilityName isEqualToString:@"VersionAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        VersionVersionAbilityViewController *otherVC = [[VersionVersionAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (VersionVersionAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"Modifier"] && [abilityName isEqualToString:@"ModifierAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        ModifierModifierAbilityViewController *otherVC = [[ModifierModifierAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (ModifierModifierAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"VideoPlayDemo"] && [abilityName isEqualToString:@"VideoPlayDemoAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        VideoPlayDemoVideoPlayDemoAbilityViewController *otherVC = [[VideoPlayDemoVideoPlayDemoAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (VideoPlayDemoVideoPlayDemoAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"FileApi"] && [abilityName isEqualToString:@"FileApiAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        FileApiFileApiAbilityViewController *otherVC = [[FileApiFileApiAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (FileApiFileApiAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"Drawing"] && [abilityName isEqualToString:@"DrawingAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        DrawingDrawingAbilityViewController *otherVC = [[DrawingDrawingAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (DrawingDrawingAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"Window"] && [abilityName isEqualToString:@"WindowAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        WindowWindowAbilityViewController *otherVC = [[WindowWindowAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (WindowWindowAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"RDBDemo"] && [abilityName isEqualToString:@"RDBDemoAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        RDBDemoRDBDemoAbilityViewController *otherVC = [[RDBDemoRDBDemoAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (RDBDemoRDBDemoAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"UDMFDemo"] && [abilityName isEqualToString:@"UDMFDemoAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        UDMFDemoUDMFDemoAbilityViewController *otherVC = [[UDMFDemoUDMFDemoAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (UDMFDemoUDMFDemoAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"PreferencesDemo"] && [abilityName isEqualToString:@"PreferencesDemoAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        PreferencesDemoPreferencesDemoAbilityViewController *otherVC = [[PreferencesDemoPreferencesDemoAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (PreferencesDemoPreferencesDemoAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"RequestDemo"] && [abilityName isEqualToString:@"RequestDemoAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        RequestDemoRequestDemoAbilityViewController *otherVC = [[RequestDemoRequestDemoAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (RequestDemoRequestDemoAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"GeoLocationManagerDemo"] && [abilityName isEqualToString:@"GeoLocationManagerDemoAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        GeoLocationManagerDemoGeoLocationManagerDemoAbilityViewController *otherVC = [[GeoLocationManagerDemoGeoLocationManagerDemoAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (GeoLocationManagerDemoGeoLocationManagerDemoAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"VibrationBasicDemo"] && [abilityName isEqualToString:@"VibrationBasicDemoAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        VibrationBasicDemoVibrationBasicDemoAbilityViewController *otherVC = [[VibrationBasicDemoVibrationBasicDemoAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (VibrationBasicDemoVibrationBasicDemoAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"VibratorCustomHapticDemo"] && [abilityName isEqualToString:@"VibratorCustomHapticDemoAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        VibratorCustomHapticDemoVibratorCustomHapticDemoAbilityViewController *otherVC = [[VibratorCustomHapticDemoVibratorCustomHapticDemoAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (VibratorCustomHapticDemoVibratorCustomHapticDemoAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"VibratorJsSamplesDemo"] && [abilityName isEqualToString:@"VibratorJsSamplesDemoAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        VibratorJsSamplesDemoVibratorJsSamplesDemoAbilityViewController *otherVC = [[VibratorJsSamplesDemoVibratorJsSamplesDemoAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (VibratorJsSamplesDemoVibratorJsSamplesDemoAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"TaskPoolDemo"] && [abilityName isEqualToString:@"TaskPoolDemoAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        TaskPoolDemoTaskPoolDemoAbilityViewController *otherVC = [[TaskPoolDemoTaskPoolDemoAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (TaskPoolDemoTaskPoolDemoAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"CollectionsDemo"] && [abilityName isEqualToString:@"CollectionsDemoAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        CollectionsDemoCollectionsDemoAbilityViewController *otherVC = [[CollectionsDemoCollectionsDemoAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (CollectionsDemoCollectionsDemoAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"FastBufferDemo"] && [abilityName isEqualToString:@"FastBufferDemoAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        FastBufferDemoFastBufferDemoAbilityViewController *otherVC = [[FastBufferDemoFastBufferDemoAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (FastBufferDemoFastBufferDemoAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"UtilsDemo"] && [abilityName isEqualToString:@"UtilsDemoAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        UtilsDemoUtilsDemoAbilityViewController *otherVC = [[UtilsDemoUtilsDemoAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (UtilsDemoUtilsDemoAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"ImageDemo"] && [abilityName isEqualToString:@"ImageDemoAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        ImageDemoImageDemoAbilityViewController *otherVC = [[ImageDemoImageDemoAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (ImageDemoImageDemoAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"I18nDemo"] && [abilityName isEqualToString:@"I18nDemoAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        I18nDemoI18nDemoAbilityViewController *otherVC = [[I18nDemoI18nDemoAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (I18nDemoI18nDemoAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"HyperlinkDemo"] && [abilityName isEqualToString:@"HyperlinkDemoAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        HyperlinkDemoHyperlinkDemoAbilityViewController *otherVC = [[HyperlinkDemoHyperlinkDemoAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (HyperlinkDemoHyperlinkDemoAbilityViewController *)otherVC;
    } else if ([moduleName isEqualToString:@"GraphicsTextDemo"] && [abilityName isEqualToString:@"GraphicsTextDemoAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        GraphicsTextDemoGraphicsTextDemoAbilityViewController *otherVC = [[GraphicsTextDemoGraphicsTextDemoAbilityViewController alloc] initWithInstanceName:instanceName];
        subStageVC = (GraphicsTextDemoGraphicsTextDemoAbilityViewController *)otherVC;
    } // other ViewController
    
    if (!subStageVC) {
        return NO;
    }
    
    if (!hasRoot) {
        [self setNavRootVC:subStageVC];
    } else {
        UINavigationController *rootNav = (UINavigationController *)self.window.rootViewController;
        [rootNav pushViewController:subStageVC animated:YES];
    }
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
    UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = UIColor.whiteColor;
    navi.navigationBar.standardAppearance = appearance;
    navi.navigationBar.scrollEdgeAppearance = navi.navigationBar.standardAppearance;
}

@end
