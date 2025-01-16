//
//  NativeViewController.m
//  app
//
//  Created by yanjunliang on 2024/12/27.
//

#import "NativeViewController.h"
#import "EntryEntryAbilityViewController.h"

@interface NativeViewController () {
    EntryEntryAbilityViewController *entryVC;
    UIView *mainView;
}

@end

@implementation NativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)createUI {
    CGFloat topHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    mainView = [[UIView alloc] init];
    mainView.frame = CGRectMake(0, topHeight, self.view.frame.size.width, self.view.frame.size.height - topHeight);
    [self.view addSubview:mainView];
    entryVC = [[EntryEntryAbilityViewController alloc] initWithInstanceName:self.instanceName];
    entryVC.view.frame = CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height);
    entryVC.view.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:entryVC.view];
    [self addChildViewController:entryVC];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
