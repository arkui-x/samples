//
//  SecondFloorViewController.m
//  app
//
//  Created by yanjunliang on 2025/9/23.
//

#import "SecondFloorViewController.h"
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
