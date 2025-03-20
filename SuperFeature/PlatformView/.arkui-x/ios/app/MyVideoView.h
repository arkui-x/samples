#ifndef MYVIDEOVIEW_H
#define MYVIDEOVIEW_H
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <libarkui_ios/IPlatformView.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyVideoView : NSObject<IPlatformView>
- (UIView *) view;
- (void) onDispose;
- (NSString *) getPlatformViewID;
- (instancetype)initWithFrame;
@end

NS_ASSUME_NONNULL_END

#endif /* MYVIDEOVIEW_H */
