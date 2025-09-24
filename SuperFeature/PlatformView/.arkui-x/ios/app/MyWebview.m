#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

#import "MyWebview.h"

@interface MyWebview ()

@end


@implementation MyWebview {
    WKWebView *webView;
    NSString* viewTag;
}

- (instancetype)initWithFrame:(NSString*) data
{
    self = [super init];
    if (self) {
        viewTag = @"WebView";
        webView = [[WKWebView alloc] init];
        NSURL *url = [NSURL URLWithString:data];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        webView.layer.allowsEdgeAntialiasing = YES;
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
