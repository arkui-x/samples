#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "MyMapView.h"

@interface MyMapView () <CLLocationManagerDelegate>

@end


@implementation MyMapView {
    MKMapView *mapView;
    NSString* viewTag;
}

- (instancetype)initWithFrame
{
    self = [super init];
    if (self) {
        viewTag = @"MapView";
        mapView = [[MKMapView alloc] init];
        mapView.showsCompass = YES;
        mapView.showsScale = YES;
        [mapView setMapType:MKMapTypeHybrid];
    }
    return self;
}

- (UIView*) view {
    return mapView;
    
}

- (void)onDispose {
    mapView = nil;
}

- (NSString*) getPlatformViewID {
    return viewTag;
}
@end
