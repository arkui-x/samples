// BridgeClass.h

// 引用平台桥接模块
#import "AppDelegate.h"
#import <libarkui_ios/BridgePlugin.h>

NS_ASSUME_NONNULL_BEGIN

@interface BridgeClass : BridgePlugin

// 获取所有的图片和视频，分类但不分页
- (NSString*)getImagesAndVideos;

// 分页获取相册资源：所有图片、视频
- (NSString*)getAlbumRes;

- (NSString*)getNextPageAlbumData;

// 根据时间来获取

- (NSString*)get3dAlbumResByPage;

- (NSString*)get3dNextPageAlbumData;

- (NSString*)get7dAlbumResByPage;

- (NSString*)get7dNextPageAlbumData;

- (NSString*)get30dAlbumResByPage;

- (NSString*)get30dNextPageAlbumData;

// 图片
- (NSString*)getAlbumPhotos;

- (NSString*)getNextPageAlbumPhotos;

// 截屏
- (NSString*)getAlbumScreenshots;

- (NSString*)getNextPageAlbumScreenshots;

// 视频
- (NSString*)getAlbumVideos;

- (NSString*)getNextPageAlbumVideos;

// 重置xcPageNo
- (NSString*)resetAlbum;

@end

NS_ASSUME_NONNULL_END
