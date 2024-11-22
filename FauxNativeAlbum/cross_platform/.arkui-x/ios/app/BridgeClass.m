// BridgeClass.m
#import "AppDelegate.h"
#import "BridgeClass.h"
#import "GlobalVariables.h"

// iOS侧方法，供ArkUI侧调用
@implementation BridgeClass

- (NSString*)getImagesAndVideos {
    return @"call objective-c getImagesAndVideos success";
}

- (NSString*)getAlbumRes {
//    [globalAppDelegate initAlbumRes];
    return @"call objective-c getAlbumRes success";
}

- (NSString*)getNextPageAlbumData {
    [globalAppDelegate getNextPageData];
    return @"call objective-c getNextPageAlbumData success";
}

// 3天、7天、一个月
- (NSString*)get3dAlbumResByPage {
    [globalAppDelegate get3dAlbumResByPage];
    return @"call objective-c get3dAlbumResByPage success";
}

- (NSString*)get3dNextPageAlbumData {
    [globalAppDelegate get3dNextPageAlbumData];
    return @"call objective-c get3dNextPageAlbumData success";
}

- (NSString*)get7dAlbumResByPage {
    [globalAppDelegate get7dAlbumResByPage];
    return @"call objective-c get7dAlbumResByPage success";
}

- (NSString*)get7dNextPageAlbumData {
    [globalAppDelegate get7dNextPageAlbumData];
    return @"call objective-c get7dNextPageAlbumData success";
}

- (NSString*)get30dAlbumResByPage {
    [globalAppDelegate get30dAlbumResByPage];
    return @"call objective-c get30dAlbumResByPage success";
}

- (NSString*)get30dNextPageAlbumData {
    [globalAppDelegate get30dNextPageAlbumData];
    return @"call objective-c get30dNextPageAlbumData success";
}

- (NSString*)getAlbumPhotos {
    [globalAppDelegate getPhotosByPage];
    return @"call objective-c getPhotosByPage success";
}

- (NSString*)getNextPageAlbumPhotos {
    [globalAppDelegate getNextPageAlbumPhotos];
    return @"call objective-c getNextPageAlbumPhotos success";
}

- (NSString*)getAlbumScreenshots {
    [globalAppDelegate getScreenshotsByPage];
    return @"call objective-c getScreenshotsByPage success";
}

- (NSString*)getNextPageAlbumScreenshots {
    [globalAppDelegate getNextPageAlbumScreenshots];
    return @"call objective-c getNextPageAlbumScreenshots success";
}

- (NSString*)getAlbumVideos {
    [globalAppDelegate getVideosByPage];
    return @"call objective-c getVideosByPage success";
}

- (NSString*)getNextPageAlbumVideos {
    [globalAppDelegate getNextPageAlbumVideos];
    return @"call objective-c getNextPageAlbumVideos success";
}

- (NSString*)resetAlbum {
    [globalAppDelegate resetXcPageNo];
    return @"call objective-c resetAlbum success";
}



@end
