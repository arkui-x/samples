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
 
#import "DynamizationJumpController.h"
#import "DynamicShowViewController.h"

#define BUNDLE_DIRECTORY @"arkui-x"

@interface DynamizationJumpController ()

@property (nonatomic, copy) NSString *filePath;

@end

@implementation DynamizationJumpController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    
    UIButton *hap = [self createButton:@"加载沙箱演示页面"];
    hap.frame = CGRectMake(15, 118, screenWidth - 30, 66);
    [hap addTarget:self action:@selector(pushHapView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hap];
    
    UIButton *one = [self createButton:@"加载沙箱演示页面1"];
    one.frame = CGRectMake(15, CGRectGetMaxY(hap.frame) + 20, screenWidth - 30, 66);
    [one addTarget:self action:@selector(pushOneView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:one];
    
    UIButton *two = [self createButton:@"加载沙箱演示页面2"];
    two.frame = CGRectMake(15, CGRectGetMaxY(one.frame) + 20, screenWidth - 30, 66);
    [two addTarget:self action:@selector(pushTwoView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:two];
    
    UIButton *cpy1 = [self createButton:@"拷贝doc文件到沙箱"];
    cpy1.frame = CGRectMake(15, CGRectGetMaxY(two.frame) + 20, screenWidth - 30, 66);
    cpy1.tag = 1;
    [cpy1 addTarget:self action:@selector(copyFileToDocuments:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cpy1];
    
    UIButton *cpy2 = [self createButton:@"拷贝resh文件到沙箱"];
    cpy2.frame = CGRectMake(15, CGRectGetMaxY(cpy1.frame) + 20, screenWidth - 30, 66);
    cpy2.tag = 2;
    [cpy2 addTarget:self action:@selector(copyFileToDocuments:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cpy2];
    
    UIButton *clear = [self createButton:@"清空沙箱文件"];
    clear.frame = CGRectMake(15, CGRectGetMaxY(cpy2.frame) + 20, screenWidth - 30, 66);
    [clear addTarget:self action:@selector(clearOldFile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clear];
}

- (UIButton *)createButton:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 15;
    button.layer.borderColor = UIColor.grayColor.CGColor;
    button.layer.borderWidth = 1;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:UIColor.whiteColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    return button;
}

- (void)pushHapView {
    DynamicShowViewController *showVC = [[DynamicShowViewController alloc] init];
    showVC.moduleName = @"dynamicHap";
    showVC.abilityName = @"DynamicHapAbility";
    [self.navigationController pushViewController:showVC animated:YES];
}

- (void)pushOneView {
    DynamicShowViewController *showVC = [[DynamicShowViewController alloc] init];
    showVC.moduleName = @"dynamicHapOne";
    showVC.abilityName = @"DynamicHapOneAbility";
    [self.navigationController pushViewController:showVC animated:YES];
}
 
- (void)pushTwoView {
    DynamicShowViewController *showVC = [[DynamicShowViewController alloc] init];
    showVC.moduleName = @"dynamicHapTwo";
    showVC.abilityName = @"DynamicHapTwoAbility";
    [self.navigationController pushViewController:showVC animated:YES];
}

- (void)copyFileToDocuments:(UIButton *)button {
    NSString *folderName = (button.tag == 1) ? @"doc" : @"resh";
    NSURL *sourceURL = [[NSBundle mainBundle] URLForResource:folderName withExtension:nil];
    if (!sourceURL) {
        NSLog(@"源文件夹不存在");
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:self.filePath]) {
        [fileManager createDirectoryAtPath:self.filePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"创建文件夹失败: %@", error.localizedDescription);
            return;
        }
    }
    [self clearOldFile];
    NSString *sourcePath = [sourceURL path];
    BOOL success = [fileManager copyItemAtPath:sourcePath toPath:self.filePath error:&error];
    if (success) {
        NSLog(@"文件夹拷贝成功，路径: %@", self.filePath);
    } else {
        NSLog(@"拷贝失败: %@", error.localizedDescription);
    }
}

- (void)clearOldFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if ([fileManager fileExistsAtPath:self.filePath]) {
        [fileManager removeItemAtPath:self.filePath error:&error];
        if (error) {
            NSLog(@"删除旧文件失败: %@", error.localizedDescription);
            return;
        }
    }
}

- (NSString *)filePath {
    if (!_filePath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths firstObject];
        _filePath = [documentsPath stringByAppendingPathComponent:@"files"];
    }
    return _filePath;
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size];
    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        [color setFill];
        [rendererContext fillRect:CGRectMake(0, 0, size.width, size.height)];
    }];
    return image;
}
@end
