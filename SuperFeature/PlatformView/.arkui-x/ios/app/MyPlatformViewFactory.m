#import <Foundation/Foundation.h>

#import "MyPlatformViewFactory.h"
#import "MyWebview.h"
#import "MyMapView.h"
#import "MyVideoView.h"

@implementation MyPlatformViewFactory {

}

- (instancetype)initWithFrame{
    return self;
}

- (NSObject<IPlatformView>*) getPlatformView:(NSString*) platformViewId {
    NSLog(@"[PlatformViewUI] getPlatfformView");
    if ([platformViewId isEqualToString:@"MapView"]) {
        NSObject<IPlatformView> * view = [[MyMapView alloc] initWithFrame];
        return view;
    } else if ([platformViewId isEqualToString:@"VideoView"]) {
        NSObject<IPlatformView> * view = [[MyVideoView alloc] initWithFrame];
        return view;
    }
    return nil;
}

- (NSObject<IPlatformView>*) getPlatformView:(NSString*) platformViewId data:(NSString*) data {
    if ([platformViewId isEqualToString:@"WebView"]) {
        NSObject<IPlatformView> * view = [[MyWebview alloc] initWithFrame:data];
        return view;
    }
    return nil;
}
@end
