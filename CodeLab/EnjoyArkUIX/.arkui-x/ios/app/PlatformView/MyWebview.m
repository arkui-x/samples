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
 
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "MyWebview.h"

@interface MyWebview ()

@end


@implementation MyWebview {
    WKWebView *webView;
    NSString* viewTag;
}

- (instancetype)initWithFrame
{
    self = [super init];
    if (self) {
        viewTag = @"WebView";
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        NSURL *url = [NSURL URLWithString:@"https://m.vmall.com/portal/activity/index.html?pn=YDJK&cid=178094&callapp=no"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        webView.frame = CGRectMake(0, 0, 50, 50);
    }
    return self;
}

- (UIView*) view {
    return webView;
}

- (void)onDispose {
    webView = nil;
}

- (NSString*) getPlatformViewID {
    return viewTag;
}
@end
