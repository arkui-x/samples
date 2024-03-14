//
//  BaseViewController.m
//  app
//
//  Created by Dordly on 2024/3/14.
//

#import "BaseViewController.h"
#import "EntryEntryAbilityViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) UIView *mainView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat top = [self getStatusBarHeight];
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, top, self.view.frame.size.width, self.view.frame.size.height - top)];
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainView];
    EntryEntryAbilityViewController *mainView = [[EntryEntryAbilityViewController alloc] initWithInstanceName:self.instanceName];
    mainView.view.frame = CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height);
    mainView.view.backgroundColor = [UIColor whiteColor];
    [self.mainView addSubview:mainView.view];
}

/// 顶部安全高度
- (CGFloat)getSafeDistanceTop {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets.top;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.top;
    }
    return 0;
}

/// 顶部状态栏高度+安全区域
- (CGFloat)getStatusBarHeight {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIStatusBarManager *statusManager = windowScene.statusBarManager;
        return statusManager.statusBarFrame.size.height;
    }
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

@end
