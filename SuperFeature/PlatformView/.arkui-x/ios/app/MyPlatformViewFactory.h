#ifndef MYPLATFORMVIEWFACTORY_H
#define MYPLATFORMVIEWFACTORY_H

#import <UIKit/UIKit.h>
#import <libarkui_ios/PlatformViewFactory.h>
#import <libarkui_ios/IPlatformView.h>

NS_ASSUME_NONNULL_BEGIN
@interface MyPlatformViewFactory : NSObject<PlatformViewFactory>

- (NSObject<IPlatformView>*) getPlatformView:(NSString*) xComponentId;
- initWithFrame;
@end
NS_ASSUME_NONNULL_END

#endif /* MYPLATFORMVIEWFACTORY_H */
