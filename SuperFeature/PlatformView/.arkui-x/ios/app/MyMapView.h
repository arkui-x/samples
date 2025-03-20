#ifndef MY_MAPVIEW_H
#define MY_MAPVIEW_H
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <libarkui_ios/IPlatformView.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyMapView : NSObject<IPlatformView>
- (UIView *) view;
- (void) onDispose;
- (NSString *) getPlatformViewID;
- (instancetype)initWithFrame;
@end

NS_ASSUME_NONNULL_END

#endif /* MY_MAPVIEW_H */
