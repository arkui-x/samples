//
//  WantViewController.m
//  app
//
//  Created by 240506 on 2025/1/20.
//

#import "WantViewController.h"

@interface WantViewController ()

@property (nonatomic , strong)UITextView *textView;

@end

@implementation WantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 100, CGRectGetWidth(self.view.frame)-30, 340)];
    textView.font = [UIFont systemFontOfSize:16.0];
    textView.textColor = [UIColor blackColor];
    textView.editable = NO; // 不可编辑
    textView.scrollEnabled = YES; // 可滚动
    textView.backgroundColor = [UIColor whiteColor]; // 背景色透明
    [self.view addSubview:textView];
    self.textView = textView;
    
    UIButton *btnGetValue = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetValue.frame = CGRectMake(15, 460, CGRectGetWidth(self.view.frame)-30, 50);
    [btnGetValue setTitle:@"GetValue" forState:UIControlStateNormal];
    [btnGetValue addTarget:self action:@selector(btnActionGetValue) forControlEvents:UIControlEventTouchUpInside];
    [btnGetValue setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btnGetValue setBackgroundColor:[UIColor.blueColor colorWithAlphaComponent:0.7]];
    [self.view addSubview:btnGetValue];
    
}

-(void)viewDidAppear:(BOOL)animated{
    self.textView.text = self.strParams;
}

- (void)btnActionGetValue{
    WantParams *wp = [[WantParams alloc]init];
    [wp addValue:@"stringKey" value:@"strArkUI"];
    NSDictionary *dic = [wp getValue];
    //dic需要进行判空
    if (dic) {
        NSString *str = [NSString stringWithFormat:@"%@",dic];
        self.textView.text = str;
    }
}
@end
