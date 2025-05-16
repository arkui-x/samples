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

#import "MainTableViewCell.h"
#import "PublicHeader.h"

@interface MainTableViewCell ()

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.publicWidth = self.contentView.frame.size.width;
    }
    return self;
}

- (void)createUI {
    if (self.mainView) {
        [self.mainView removeFromSuperview];
    }
    [self.contentView addSubview:self.mainView];
    [self.mainView addSubview:self.titleLabel];
    CGFloat cellWidth = (self.publicWidth - PUBLIC_SPACE * 2);
    self.mainView.frame = CGRectMake(PUBLIC_SPACE, 15, cellWidth, 65);
    self.titleLabel.frame = CGRectMake(0, 0, cellWidth, 65);
}

- (void)setPublicWidth:(CGFloat)publicWidth {
    _publicWidth = publicWidth;
    [self createUI];
}

- (void)setTitleName:(NSString *)titleName {
    self.titleLabel.text = titleName;
}

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [UIColor systemBlueColor];
        _mainView.layer.masksToBounds = YES;
        _mainView.layer.cornerRadius = 12;
    }
    return _mainView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
