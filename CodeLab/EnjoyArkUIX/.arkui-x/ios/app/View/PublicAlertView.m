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

#import "PublicAlertView.h"

@interface PublicAlertView ()

@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UILabel *titleLable;

@end

@implementation PublicAlertView

- (instancetype)initWithFrame:(CGRect)frame mainTitle:(NSString *)mainTitle {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.frame = frame;
        [self addSubview:self.centerView];
        self.titleLable.text = mainTitle;
        [self.centerView addSubview:self.titleLable];
        self.hidden = YES;
        self.centerView.hidden = YES;
    }
    return self;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _centerView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        _centerView.layer.masksToBounds = YES;
        _centerView.layer.cornerRadius = 12;
        _centerView.backgroundColor = [UIColor whiteColor];
    }
    return _centerView;
}

- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _titleLable.font = [UIFont boldSystemFontOfSize:14.0];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.alpha = 0.8;
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}

- (void)hideView {
    self.hidden = YES;
    self.centerView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.centerView.frame = CGRectMake(0, 0, 0, 0);
        self.centerView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    }];
}

- (void)showView {
    self.hidden = NO;
    self.centerView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.centerView.frame = CGRectMake(0, 0, 100, 40);
        self.centerView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        [self performSelector:@selector(hideView) withObject:self afterDelay:2];
    }];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleLable.text = titleStr;
}

@end
