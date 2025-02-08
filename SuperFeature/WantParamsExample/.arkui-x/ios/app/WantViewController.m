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
    id params = [wp getValue:@"stringKey"];
    //注意 params需要进行判空
    if (params) {
        NSString *str = [NSString stringWithFormat:@"%@",params];
        self.textView.text = str;
    }
}
@end
