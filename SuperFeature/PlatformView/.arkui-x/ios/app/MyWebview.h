#ifndef MY_WEBVIEW_H
#define MY_WEBVIEW_H
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <libarkui_ios/IPlatformView.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyWebview : NSObject<IPlatformView>
- (UIView *) view;
- (void) onDispose;
- (NSString *) getPlatformViewID;
- initWithFrame;
@end

NS_ASSUME_NONNULL_END

#endif /* MY_WEBVIEW_H */
