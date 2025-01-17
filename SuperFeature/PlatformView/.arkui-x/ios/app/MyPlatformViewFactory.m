#import <Foundation/Foundation.h>
#import "MyPlatformViewFactory.h"
#import "MyWebview.h"
#import "MyMapView.h"

@implementation MyPlatformViewFactory {

}

- (instancetype)initWithFrame{
    return self;
}

- (NSObject<IPlatformView>*) getPlatformView:(NSString*) xComponentId {
    NSLog(@"[PlatformViewUI] getPlatfformView");
    if ([xComponentId isEqualToString:@"WebView"]) {
        NSObject<IPlatformView> * view = [[MyWebview alloc] initWithFrame];
        return view;
    } else if ([xComponentId isEqualToString:@"MapView"]) {
        NSObject<IPlatformView> * view = [[MyMapView alloc] initWithFrame];
        return view;
    }
    return nil;
}
@end
