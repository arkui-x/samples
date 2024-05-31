/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AppDelegate.h"
#import "EntryEntryAbilityViewController.h"
#import <libarkui_ios/BridgePlugin.h>
#import <libarkui_ios/StageApplication.h>
#import "BridgeClass.h"
#import "AlbumInfo.h"
#import "GlobalVariables.h"

#define BUNDLE_DIRECTORY @"arkui-x"
#define BUNDLE_NAME @"com.example.test"

@interface AppDelegate ()
<IMessageListener> {}
@property (nonatomic, strong) BridgeClass* plugin;
@end

@implementation AppDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        // 使用 setter 方法设置默认值
        self.pageNo = 1;
        self.page3dNo = 1;
        self.page7dNo = 1;
        self.page30dNo = 1;
        self.xcPageNo = 1;
        self.pageSize = 20;
        self.pageNextSize = 20;
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [StageApplication configModuleWithBundleDirectory:BUNDLE_DIRECTORY];
    [StageApplication launchApplication];
    
    NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",BUNDLE_NAME, @"entry", @"EntryAbility"];
    EntryEntryAbilityViewController *mainView = [[EntryEntryAbilityViewController alloc] initWithInstanceName:instanceName];
    [self setNavRootVC:mainView];
    
    // 建立与ArkUI侧同名的平台桥接，即可用于消息传递
    int32_t instanceId = [mainView getInstanceId];
    self.plugin = [[BridgeClass alloc] initBridgePlugin:@"Bridge" instanceId:instanceId];
    self.plugin.messageListener = self;
    // 使用方法设置全局变量
    [GlobalVariables setGlobalAppDelegate:self];
    
    // 请求相册授权
    [self requestAlbumAuthorization];
    
    return YES;
}

// 请求相册权限
- (void)requestAlbumAuthorization {
    // 请求授权，需要实现PHPhotoLibrary协议
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusNotDetermined:
                // 用户还未决定是否授权，可以继续请求授权
                NSLog(@"用户还未决定是否授权，可以继续请求授权");
                break;
            case PHAuthorizationStatusAuthorized:
                // 用户已授权，可以访问相册
                NSLog(@"用户已授权，可以访问相册");
                [self initAlbumRes];//ios授权后会默认进入
                break;
            case PHAuthorizationStatusDenied:
                // 用户拒绝授权，可以提示用户开启权限
                NSLog(@"用户拒绝授权，可以提示用户开启权限");
                break;
            case PHAuthorizationStatusRestricted:
                // 用户由于某种限制无法访问相册，可以提示用户开启权限
                NSLog(@"用户由于某种限制无法访问相册，可以提示用户开启权限");
                break;
            default:
                break;
        }
    }];
}

// 初始化获取相册资源
- (void)initAlbumRes {
    [self getImagesAndVideos];
    [self getImagesAndVideosByPage];
    [self getScreenInfo];
}

// 获取屏幕密度
- (void)getScreenInfo {
    NSMutableArray *array = [NSMutableArray array];
    CGFloat screenScale = [UIScreen mainScreen].scale;
    [array addObject:@(screenScale)];
    MethodData* method = [[MethodData alloc] initMethodWithName:@"getScreenInfo" parameter:array];
    [self.plugin callMethod:method];
}

// 重置pageNo
- (void)resetPageNo {
    self.pageNo = 1;
}

// 重置xcPageNo
- (void)resetXcPageNo {
    self.xcPageNo = 1;
}

// 获取所有的图片和视频，分类但不分页
- (void)getImagesAndVideos {
    NSArray<PHAsset *> *all = [self fetchAlbumsPage:@"all"];
    
    NSArray<PHAsset *> *photos = [self fetchAlbumsPage:@"photos"];
    
    NSArray<PHAsset *> *screenshots = [self fetchScreenshot];
    
    NSArray<PHAsset *> *videos = [self fetchAlbumsPage:@"videos"];
    
    NSLog(@"getImagesAndVideos: %lu", all.count);
    NSLog(@"getImagesAndVideos: %lu", photos.count);
    NSLog(@"getImagesAndVideos: %lu", screenshots.count);
    NSLog(@"getImagesAndVideos: %lu", videos.count);
    
    [self handleHashMap:photos screenshots:screenshots videos:videos];
    
}

// 分页获取相册所有资源
- (void)getImagesAndVideosByPage {
    NSArray<PHAsset *> *combinedAssets = [self fetchAlbumsPage:@"all"];
    [self handlePageResult:combinedAssets type:@"all" timeType:@"all"];
}

// 分页获取相册下一页资源
- (void)getNextPageData {
    self.pageNo = self.pageNo + 1;
    [self getImagesAndVideosByPage];
}

- (void)get3dAlbumResByPage {
    NSArray<PHAsset *> *combinedAssets = [self fetchAlbumsPage:@"all"];
    [self handlePageResult:combinedAssets type:@"all" timeType:@"3d"];
}

- (void)get3dNextPageAlbumData {
    self.page3dNo = self.page3dNo + 1;
    NSArray<PHAsset *> *combinedAssets = [self fetchAlbumsPage:@"all"];
    [self handlePageResult:combinedAssets type:@"all" timeType:@"3d"];
}

- (void)get7dAlbumResByPage {
    NSArray<PHAsset *> *combinedAssets = [self fetchAlbumsPage:@"all"];
    [self handlePageResult:combinedAssets type:@"all" timeType:@"7d"];
}

- (void)get7dNextPageAlbumData {
    self.page7dNo = self.page7dNo + 1;
    NSArray<PHAsset *> *combinedAssets = [self fetchAlbumsPage:@"all"];
    [self handlePageResult:combinedAssets type:@"all" timeType:@"7d"];
}

- (void)get30dAlbumResByPage {
    NSArray<PHAsset *> *combinedAssets = [self fetchAlbumsPage:@"all"];
    [self handlePageResult:combinedAssets type:@"all" timeType:@"30d"];
}

- (void)get30dNextPageAlbumData {
    self.page30dNo = self.page30dNo + 1;
    NSArray<PHAsset *> *combinedAssets = [self fetchAlbumsPage:@"all"];
    [self handlePageResult:combinedAssets type:@"all" timeType:@"30d"];
}

// 分页获取图片
- (void)getPhotosByPage {
    NSArray<PHAsset *> *photos = [self fetchAlbumsPage:@"photos"];
    [self handlePageResult:photos type:@"photos" timeType:@"all"];
}

// 分页获取图片下一页资源
- (void)getNextPageAlbumPhotos {
    self.xcPageNo = self.xcPageNo + 1;
    [self getPhotosByPage];
}

// 分页获取截屏
- (void)getScreenshotsByPage {
    NSArray<PHAsset *> *screenshots = [self fetchScreenshot];
    
    NSLog(@"screenshots screenshots: %lu", (unsigned long)screenshots.count);
    
    [self handleScreenshotsPageResult:screenshots];
}

// 分页获取截屏下一页资源
- (void)getNextPageAlbumScreenshots {
    self.xcPageNo = self.xcPageNo + 1;
    [self getScreenshotsByPage];
}

// 分页获取视频
- (void)getVideosByPage {
    NSArray<PHAsset *> *videos = [self fetchAlbumsPage:@"videos"];
    [self handlePageResult:videos type:@"videos" timeType:@"all"];
}

// 分页获取视频下一页资源
- (void)getNextPageAlbumVideos {
    self.xcPageNo = self.xcPageNo + 1;
    [self getVideosByPage];
}


// 不分页的向arkui返回hashmap的json格式
- (void)handleHashMap:(NSArray<PHAsset *> *)photos screenshots:(NSArray<PHAsset *> *)screenshots videos:(NSArray<PHAsset *> *)videos {
    NSMutableDictionary *myHashMap = [NSMutableDictionary dictionary];
    // 获取photos
    if(photos.count > 0) {
        [self fetchURLAndCreateTimeForImage:photos[0] completion:^(NSURL *url1, NSDate *createTime) {
            if (url1) {
                NSString *url1String = [url1 absoluteString];
                [myHashMap setObject:@[url1String] forKey:@"photos"];
                [myHashMap setObject:@(photos.count) forKey:@"photosSize"];
                if(screenshots.count > 0) {
                    // 获取screenshots
                    [self fetchURLAndCreateTimeForImage:screenshots[0] completion:^(NSURL *url2, NSDate *createTime) {
                        if (url2) {
                            NSString *url2String = [url2 absoluteString];
                            [myHashMap setObject:@[url2String] forKey:@"screenshots"];
                            [myHashMap setObject:@(screenshots.count) forKey:@"screenshotsSize"];
                            if(videos.count > 0) {
                                // 获取videos
                                [self fetchURLAndCreateTimeForVideo:videos[0] completion:^(NSURL *url3, NSDate *createTime) {
                                    if (url3) {
                                        NSString *url3String = [url3 absoluteString];
                                        [myHashMap setObject:@[url3String] forKey:@"videos"];
                                        [myHashMap setObject:@(videos.count) forKey:@"videosSize"];
                                        [self handleHashMapJson:myHashMap];
                                    }
                                }];
                            }else {
                                [myHashMap setObject:@[@""] forKey:@"photos"];
                                [myHashMap setObject:@(photos.count) forKey:@"photosSize"];
                                [myHashMap setObject:@[@""] forKey:@"screenshots"];
                                [myHashMap setObject:@(screenshots.count) forKey:@"screenshotsSize"];
                                [myHashMap setObject:@[@""] forKey:@"videos"];
                                [myHashMap setObject:@(videos.count) forKey:@"videosSize"];
                                [self handleHashMapJson:myHashMap];
                                
                            }
                        }
                    }];
                }else {
                    if(videos.count > 0) {
                        // 获取videos
                        [self fetchURLAndCreateTimeForVideo:videos[0] completion:^(NSURL *url3, NSDate *createTime) {
                            if (url3) {
                                [myHashMap setObject:@[@""] forKey:@"photos"];
                                [myHashMap setObject:@(photos.count) forKey:@"photosSize"];
                                [myHashMap setObject:@[@""] forKey:@"screenshots"];
                                [myHashMap setObject:@(screenshots.count) forKey:@"screenshotsSize"];
                                NSString *url3String = [url3 absoluteString];
                                [myHashMap setObject:@[url3String] forKey:@"videos"];
                                [myHashMap setObject:@(videos.count) forKey:@"videosSize"];
                                [self handleHashMapJson:myHashMap];
                            }
                        }];
                    }else {
                        [myHashMap setObject:@[@""] forKey:@"photos"];
                        [myHashMap setObject:@(photos.count) forKey:@"photosSize"];
                        [myHashMap setObject:@[@""] forKey:@"screenshots"];
                        [myHashMap setObject:@(screenshots.count) forKey:@"screenshotsSize"];
                        [myHashMap setObject:@[@""] forKey:@"videos"];
                        [myHashMap setObject:@(videos.count) forKey:@"videosSize"];
                        [self handleHashMapJson:myHashMap];
                    }
                }
            }
        }];
    }else {
        if(videos.count > 0) {
            // 获取videos
            [self fetchURLAndCreateTimeForVideo:videos[0] completion:^(NSURL *url3, NSDate *createTime) {
                if (url3) {
                    [myHashMap setObject:@[@""] forKey:@"photos"];
                    [myHashMap setObject:@(photos.count) forKey:@"photosSize"];
                    [myHashMap setObject:@[@""] forKey:@"screenshots"];
                    [myHashMap setObject:@(screenshots.count) forKey:@"screenshotsSize"];
                    NSString *url3String = [url3 absoluteString];
                    [myHashMap setObject:@[url3String] forKey:@"videos"];
                    [myHashMap setObject:@(videos.count) forKey:@"videosSize"];
                    [self handleHashMapJson:myHashMap];
                }
            }];
        }else {
            [myHashMap setObject:@[@""] forKey:@"photos"];
            [myHashMap setObject:@(photos.count) forKey:@"photosSize"];
            [myHashMap setObject:@[@""] forKey:@"screenshots"];
            [myHashMap setObject:@(screenshots.count) forKey:@"screenshotsSize"];
            [myHashMap setObject:@[@""] forKey:@"videos"];
            [myHashMap setObject:@(videos.count) forKey:@"videosSize"];
            [self handleHashMapJson:myHashMap];
        }
    }
    
}

- (void)handleHashMapJson:(NSMutableDictionary *)myHashMap {
    
    @try {
        // 将字典转换为 JSON 格式的 NSData
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:myHashMap options:NSJSONWritingPrettyPrinted error:&error];

        if (jsonData) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"JSON String: %@", jsonString);
            
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:jsonString];
            MethodData* method = [[MethodData alloc] initMethodWithName:@"getImagesAndVideos" parameter:array];
            [self.plugin callMethod:method];
            
        } else {
            // 转换失败，处理错误
            NSLog(@"Error converting dictionary to JSON: %@", error.localizedDescription);
        }
    } @catch (NSException *exception) {
        NSLog(@"exception String: %@", exception);
    }
    
}


// 分页获取相册资源
- (NSArray<PHAsset *> *)fetchAlbumsPage:(NSString *)type {
    // 创建获取相机胶卷的 Fetch Options
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    
    // 按创建时间排序
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    NSArray<PHAsset *> *combinedAssets;
    // 获取相册中的所有资源（图片和视频）
    if([type isEqual: @"all"]) {
        PHFetchResult *photos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
        PHFetchResult *videos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:fetchOptions];
        
        // 将两个数组合并为一个
        combinedAssets = [photos objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, photos.count)]];
        combinedAssets = [combinedAssets arrayByAddingObjectsFromArray:[videos objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, videos.count)]]];
    }
    
    if([type isEqual: @"photos"]) {
        PHFetchResult *photos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
        
        combinedAssets = [photos objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, photos.count)]];
    }
    
    if([type isEqual: @"videos"]) {
        PHFetchResult *videos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:fetchOptions];
        
        combinedAssets = [videos objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, videos.count)]];
    }
    
    
    // 按创建时间排序
    combinedAssets = [combinedAssets sortedArrayUsingComparator:^NSComparisonResult(PHAsset *asset1, PHAsset *asset2) {
        return [asset2.creationDate compare:asset1.creationDate]; // 降序排序
    }];
    
    // 创建一个包含所有合并后的 PHAsset 的新 PHFetchResult
    //    PHFetchResult *combinedResult = [PHFetchResult fetchResultWithObjects:combinedAssets];
    
    return combinedAssets;
}

// 处理数据,向arkui返回分页结果
- (void)handlePageResult:(NSArray<PHAsset *> *)combinedAssets type:(NSString *)type timeType:(NSString *)timeType {
    // 计算分页范围
    NSInteger totalPhotos = combinedAssets.count;
    NSInteger startIndex;
    NSInteger endIndex;
    
    if([type isEqual: @"all"]) {
        startIndex = (self.pageNo - 1) * self.pageSize;
        endIndex = MIN(self.pageNo * self.pageSize, totalPhotos);
        if([timeType isEqual: @"3d"]) {
            startIndex = (self.page3dNo - 1) * self.pageSize;
            endIndex = MIN(self.page3dNo * self.pageSize, totalPhotos);
        }
        if([timeType isEqual: @"7d"]) {
            startIndex = (self.page7dNo - 1) * self.pageSize;
            endIndex = MIN(self.page7dNo * self.pageSize, totalPhotos);
        }
        if([timeType isEqual: @"30d"]) {
            startIndex = (self.page30dNo - 1) * self.pageSize;
            endIndex = MIN(self.page30dNo * self.pageSize, totalPhotos);
        }
    }else {
        startIndex = (self.xcPageNo - 1) * self.pageSize;
        endIndex = MIN(self.xcPageNo * self.pageSize, totalPhotos);
    }
    
    NSLog(@"相册pagedIndex: %lu", startIndex);
    NSLog(@"相册pagedIndex: %lu", endIndex);
    
    if(startIndex >= endIndex) {
        
        NSMutableArray<AlbumInfo *> *assetsArray = [NSMutableArray array];
        [self bridgeIOSMessage:assetsArray timeTpye:timeType];
        
    }else {
        
        // 提取分页范围内的资源
        NSRange range = NSMakeRange(startIndex, endIndex - startIndex);
        NSArray<PHAsset *> *pagedAssets = [combinedAssets objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        
        NSLog(@"相册pagedAssets: %lu", pagedAssets.count);
        // 处理分页结果
        NSMutableArray<AlbumInfo *> *assetsArray = [NSMutableArray array];
        [pagedAssets enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
            // 处理每个媒体资源
            // 此处是异步处理
            // 根据媒体类型（图片或视频）处理不同的业务逻辑
            if (asset.mediaType == PHAssetMediaTypeImage) {
                [self fetchURLAndCreateTimeForImage:asset completion:^(NSURL *url, NSDate *createTime) {
                    if (url) {
                        // 创建 AlbumInfo 对象并设置 createTime 和 url
                        AlbumInfo *photoInfo = [[AlbumInfo alloc] init];
                        NSTimeInterval createTimeInTimeInterval = [createTime timeIntervalSince1970];
                        long createTimeInLong = (long)createTimeInTimeInterval;
                        photoInfo.createTime = *(&(createTimeInLong));
                        photoInfo.uri = [url absoluteString];
                        
                        [assetsArray addObject:photoInfo]; // 将 PhotoInfo 对象添加到数组
                        
                        NSLog(@"相册资源 %@", url);
                        NSLog(@"相册资源 %ld", photoInfo.createTime);
                        NSLog(@"相册index: %lu", (unsigned long)idx);
                        
                        // 最后一个idx
                        if(idx == (endIndex - startIndex) - 1) {
                            [self bridgeIOSMessage:assetsArray timeTpye:timeType];
                        }
                    }
                }];
            } else if (asset.mediaType == PHAssetMediaTypeVideo) {
                [self fetchURLAndCreateTimeForVideo:asset completion:^(NSURL *url, NSDate *createTime) {
                    if (url) {
                        // 创建 AblumInfo 对象并设置 createTime 和 url
                        AlbumInfo *videoInfo = [[AlbumInfo alloc] init];
                        NSTimeInterval createTimeInTimeInterval = [createTime timeIntervalSince1970];
                        long createTimeInLong = (long)createTimeInTimeInterval;
                        videoInfo.createTime = *(&(createTimeInLong));
                        videoInfo.uri = [url absoluteString];
                        
                        [assetsArray addObject:videoInfo]; // 将 VideoInfo 对象添加到数组
                        
                        NSLog(@"相册视频 %@", url);
                        NSLog(@"相册图片 %ld", videoInfo.createTime);
                        NSLog(@"相册index: %lu", (unsigned long)idx);
                        
                        // 最后一个idx
                        if(idx == (endIndex - startIndex) - 1) {
                            [self bridgeIOSMessage:assetsArray timeTpye:timeType];
                        }
                        
                    }
                }];
            }
        }];
    }
}

// 向arkui端传递相册资源
- (void)bridgeIOSMessage:(NSMutableArray<AlbumInfo *> *)assetsArray timeTpye:(NSString *)timeTpye {
    // 按照 createTime 倒序排列 assetsArray
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO];
    NSArray *sortedArray = [assetsArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    NSArray *filteredArray = sortedArray;
    
    if([timeTpye isEqual: @"3d"]) {
        // 获取当前时间的时间戳
        NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];

        // 计算三天前的时间戳
        NSTimeInterval threeDaysAgoTimestamp = currentTimestamp - (3 * 24 * 60 * 60); // 3天的秒数

        // 将时间戳转换为 NSNumber
        NSNumber *threeDaysAgoNumber = @(threeDaysAgoTimestamp);

        // 使用谓词过滤数组
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createTime >= %@", threeDaysAgoNumber];
        filteredArray = [sortedArray filteredArrayUsingPredicate:predicate];
    }
    if([timeTpye isEqual: @"7d"]) {
        // 获取当前时间的时间戳
        NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];

        // 计算三天前的时间戳
        NSTimeInterval sevenDaysAgoTimestamp = currentTimestamp - (7 * 24 * 60 * 60); // 7天的秒数

        // 将时间戳转换为 NSNumber
        NSNumber *sevenDaysAgoNumber = @(sevenDaysAgoTimestamp);

        // 使用谓词过滤数组
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createTime >= %@", sevenDaysAgoNumber];
        filteredArray = [sortedArray filteredArrayUsingPredicate:predicate];
    }
    if([timeTpye isEqual: @"30d"]) {
        // 获取当前时间的时间戳
        NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];

        // 计算三天前的时间戳
        NSTimeInterval thirtyDaysAgoTimestamp = currentTimestamp - (30 * 24 * 60 * 60); // 30天的秒数

        // 将时间戳转换为 NSNumber
        NSNumber *thirtyDaysAgoNumber = @(thirtyDaysAgoTimestamp);

        // 使用谓词过滤数组
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createTime >= %@", thirtyDaysAgoNumber];
        filteredArray = [sortedArray filteredArrayUsingPredicate:predicate];
    }
    
    // 输出筛选后的数组
    NSLog(@"Filtered Array: %@", filteredArray);
    
    // 将 sortedArray 组装成 dictArray，并转换成 JSON 数据
    NSError *error;
    NSMutableArray *dictArray = [[NSMutableArray alloc] init];
    for (AlbumInfo *info in filteredArray) {
        [dictArray addObject:@{@"createTime": @(info.createTime), @"uri": info.uri}];
    }
    NSData *jsonData;
    jsonData = [NSJSONSerialization dataWithJSONObject:dictArray options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        // 转换成功，将 JSON 数据转换成字符串
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON格式数据11:\n%@", jsonString);
        [self.plugin sendMessage:jsonString];
    } else {
        // 转换失败，处理错误
        NSLog(@"JSON转换失败: %@", error.localizedDescription);
    }
}

// 获取相册中的截屏图片
- (NSArray<PHAsset *> *)fetchScreenshot {
    
    // 获取截屏文件夹
    PHFetchResult<PHAssetCollection *> * fetchResultCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumScreenshots options:nil];
    PHAssetCollection *screenshotCollection = [fetchResultCollection firstObject];
    
    // 获取截屏文件夹中的所有资产
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:screenshotCollection options:fetchOptions];
    
    NSMutableArray<PHAsset *> *combinedAssets = [NSMutableArray array];

    [fetchResult enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        if ([object isKindOfClass:[PHAsset class]]) {
            [combinedAssets addObject:object];
        }
    }];
    
    return combinedAssets;
    
}

- (void)handleScreenshotsPageResult:(NSArray<PHAsset *> *)combinedAssets {
    // 计算分页范围
    NSInteger totalPhotos = combinedAssets.count;
    NSInteger startIndex = (self.xcPageNo - 1) * self.pageSize;
    NSInteger endIndex = MIN(self.xcPageNo * self.pageSize, totalPhotos);
    
    NSLog(@"相册截屏pagedIndex: %lu", startIndex);
    NSLog(@"相册截屏pagedIndex: %lu", endIndex);
    
    NSMutableArray<AlbumInfo *> *screenshotsArr = [NSMutableArray array];
    
    if(startIndex >= endIndex) {
        
        [self bridgeIOSMessage:screenshotsArr timeTpye:@"all"];
        
    }else {
        
        // 提取分页范围内的资源
        NSRange range = NSMakeRange(startIndex, endIndex - startIndex);
        NSArray<PHAsset *> *pagedAssets = [combinedAssets objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        
        NSLog(@"相册pagedAssets: %lu", pagedAssets.count);
        
        
        // 遍历所有截屏
        [pagedAssets enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
            // 处理每个媒体资源
            // 此处是异步处理
            [self fetchURLAndCreateTimeForImage:asset completion:^(NSURL *url, NSDate *createTime) {
                if (url) {
                    // 创建 AlbumInfo 对象并设置 createTime 和 url
                    AlbumInfo *photoInfo = [[AlbumInfo alloc] init];
                    NSTimeInterval createTimeInTimeInterval = [createTime timeIntervalSince1970];
                    long createTimeInLong = (long)createTimeInTimeInterval;
                    photoInfo.createTime = *(&(createTimeInLong));
                    photoInfo.uri = [url absoluteString];
                    
                    [screenshotsArr addObject:photoInfo]; // 将 PhotoInfo 对象添加到数组
                    
                    NSLog(@"相册图片 %@", url);
                    NSLog(@"相册图片 %ld", photoInfo.createTime);
                    NSLog(@"相册index: %lu", (unsigned long)idx);
                    // 检查当前索引是否为最后一张图片
                    if (idx == pagedAssets.count - 1) {
                        // 执行你的函数
                        [self bridgeIOSScreenshot:screenshotsArr];
                    }
                }
            }];
        }];
        
    }
}

// 向arkui端传递截图
- (void)bridgeIOSScreenshot:(NSMutableArray<AlbumInfo *> *)screenshotsArr {
    // 将 assetsArray 组装成 dictArray，并转换成 JSON 数据
    NSError *error;
    NSMutableArray *dictArray = [[NSMutableArray alloc] init];
    for (AlbumInfo *info in screenshotsArr) {
        [dictArray addObject:@{@"createTime": @(info.createTime), @"uri": info.uri}];
    }
    NSData *jsonData;
    jsonData = [NSJSONSerialization dataWithJSONObject:dictArray options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        // 转换成功，将 JSON 数据转换成字符串
        NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON格式数据:\n%@", jsonString);
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:jsonString];
        //        NSLog(@"JSON格式数据:\n%@", array);
        MethodData* method = [[MethodData alloc] initMethodWithName:@"getIOSScreenshot" parameter:array];
        [self.plugin callMethod:method];
    } else {
        // 转换失败，处理错误
        NSLog(@"JSON转换失败: %@", error.localizedDescription);
    }
}


// 获取所有图片
- (void)fetchPhotos:(PHFetchOptions *)fetchOptions {
    // 获取所有照片
    PHFetchResult *photos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    NSMutableArray<AlbumInfo *> *photoInfoArray = [NSMutableArray array];
    [photos enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        // 处理每个媒体资源
        // 此处是异步处理
        [self fetchURLAndCreateTimeForImage:asset completion:^(NSURL *url, NSDate *createTime) {
            if (url) {
                // 创建 AlbumInfo 对象并设置 createTime 和 url
                AlbumInfo *photoInfo = [[AlbumInfo alloc] init];
                NSTimeInterval createTimeInTimeInterval = [createTime timeIntervalSince1970];
                long createTimeInLong = (long)createTimeInTimeInterval;
                photoInfo.createTime = *(&(createTimeInLong));
                photoInfo.uri = [url absoluteString];
                
                [photoInfoArray addObject:photoInfo]; // 将 PhotoInfo 对象添加到数组
                
                NSLog(@"相册图片 %@", url);
                NSLog(@"相册图片 %ld", photoInfo.createTime);
                NSLog(@"相册index: %lu", (unsigned long)idx);
                // 检查当前索引是否为最后一张图片
                if (idx == photos.count - 1) {
                    // 执行你的函数
                    [self fetchVideos:fetchOptions :photoInfoArray];
                }
            }
        }];
    }];
}

// 图片获取完后，获取所有的视频
- (void)fetchVideos:(PHFetchOptions *)fetchOptions :(NSMutableArray<AlbumInfo *> *)photoInfoArray {
    // 获取所有视频
    PHFetchResult *videos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:fetchOptions];
    NSMutableArray<AlbumInfo *> *videoInfoArray = [NSMutableArray array];
    [videos enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        [self fetchURLAndCreateTimeForVideo:asset completion:^(NSURL *url, NSDate *createTime) {
            if (url) {
                // 创建 AblumInfo 对象并设置 createTime 和 url
                AlbumInfo *videoInfo = [[AlbumInfo alloc] init];
                NSTimeInterval createTimeInTimeInterval = [createTime timeIntervalSince1970];
                long createTimeInLong = (long)createTimeInTimeInterval;
                videoInfo.createTime = *(&(createTimeInLong));
                videoInfo.uri = [url absoluteString];
                
                [videoInfoArray addObject:videoInfo]; // 将 VideoInfo 对象添加到数组
                
                NSLog(@"相册视频 %@", url);
                NSLog(@"相册图片 %ld", videoInfo.createTime);
                NSLog(@"相册index: %lu", (unsigned long)idx);
                // 检查当前索引是否为最后一个视频
                if (idx == videos.count - 1) {
                    [self sendMergedArrayJson:photoInfoArray :videoInfoArray];
                }
            }
        }];
    }];
}

- (void)sendMergedArrayJson:(NSMutableArray<AlbumInfo *> *)photoInfoArray :(NSMutableArray<AlbumInfo *> *)videoInfoArray {
    NSLog(@"图片和视频 photoInfoArray count: %lu", photoInfoArray.count);
    NSLog(@"图片和视频 videoInfos count: %lu", videoInfoArray.count);
    
    NSString *mergedArrayJson = [self mergeAndSortAblumInfos:photoInfoArray videoInfos:videoInfoArray];
    [self.plugin sendMessage:mergedArrayJson];
}

// 合并图片和视频，并返回合并后的json格式
- (NSString *)mergeAndSortAblumInfos:(NSMutableArray<AlbumInfo *> *)photoInfoArray videoInfos:(NSMutableArray<AlbumInfo *> *)videoInfoArray {
    // 合并两个数组
    NSMutableArray<AlbumInfo *> *mergedArray = [NSMutableArray arrayWithArray:photoInfoArray];
    [mergedArray addObjectsFromArray:videoInfoArray];
    
    // 使用 NSSortDescriptor 对 mergedArray 按照 createTime 进行排序
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:YES];
    [mergedArray sortUsingDescriptors:@[sortDescriptor]];
    
    
    NSLog(@"图片和视频 mergedArray count: %lu", mergedArray.count);
    
    // 将 mergedArray 转换成 JSON 数据
    NSError *error;
    
    NSMutableArray *dictArray = [[NSMutableArray alloc] init];
    for (AlbumInfo *info in mergedArray) {
        [dictArray addObject:@{@"createTime": @(info.createTime), @"uri": info.uri}];
    }
    NSLog(@"图片和视频 dictArray count: %lu", dictArray.count);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictArray options:NSJSONWritingPrettyPrinted error:&error];
    //    NSLog(@"jsonData length:\n%lu", jsonData.length);
    
    if (!error) {
        // 转换成功，将 JSON 数据转换成字符串
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //        NSLog(@"JSON格式数据:\n%@", jsonString);
        return jsonString;
    } else {
        // 转换失败，处理错误
        NSLog(@"JSON转换失败: %@", error.localizedDescription);
        return @"JSON转换失败";
    }
}

- (void)fetchURLAndCreateTimeForImage:(PHAsset *)asset completion:(void (^)(NSURL *url, NSDate *createTime))completion {
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestImageDataForAsset:asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        NSLog(@"相册资源imageData");//第二次获取pageNo= 2到这里打印不出来
        if (imageData) {
            // 获取原始文件名
            NSString *originalFilename = [self originalFilenameForAsset:asset];

            // 构建目标文件路径，保留原始后缀名
            NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:originalFilename];

            // 如果是 HEIC 格式，将其转换为 JPEG
            if ([dataUTI isEqualToString:@"public.heic"]) {
                UIImage *heicImage = [UIImage imageWithData:imageData];
                NSData *jpegData = UIImageJPEGRepresentation(heicImage, 1.0);
                [jpegData writeToFile:imageFilePath atomically:YES];
            } else {
                // 不是 HEIC 格式，直接写入文件
                [imageData writeToFile:imageFilePath atomically:YES];
            }
            
            NSURL *url = [NSURL fileURLWithPath:imageFilePath];
            
            // 获取创建时间
            NSDate *createTime = asset.creationDate;
            
            
            NSLog(@"相册资源createTime");

            completion(url, createTime);
        } else {
            completion(nil, nil);
        }
    }];
}

- (void)fetchURLAndCreateTimeForVideo:(PHAsset *)asset completion:(void (^)(NSURL *url, NSDate *createTime))completion {
    PHImageManager *manager = [PHImageManager defaultManager];

    [manager requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset *avAsset, AVAudioMix *audioMix, NSDictionary *info) {
        if ([avAsset isKindOfClass:[AVURLAsset class]]) {
            AVURLAsset *urlAsset = (AVURLAsset *)avAsset;
            NSURL *url = urlAsset.URL;

            // 获取创建时间
            NSDate *createTime = asset.creationDate;

            completion(url, createTime);
        } else {
            completion(nil, nil);
        }
    }];
}

- (NSString *)originalFilenameForAsset:(PHAsset *)asset {
    PHAssetResource *originalResource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    return originalResource.originalFilename;
}

// 监听ArkUI侧发来的消息
#pragma mark - listener
- (NSString *)onMessage:(id)data {
    return @"oc onMessage success";
}

- (void)onMessageResponse:(id)data {
    NSLog(@"oc onMessage onMessageResponse");
}



- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    NSLog(@"appdelegate openUrl callback, url : %@", url.absoluteString); // eg: (com.entry.arkui://entry?OtherAbility)
    
    NSString *bundleName = url.scheme;
    NSString *moduleName = url.host;
    NSString *abilityName, *params;

    NSURLComponents * urlComponents = [NSURLComponents componentsWithString:url.absoluteString];
    NSArray <NSURLQueryItem *> *array = urlComponents.queryItems;
    for (NSURLQueryItem * item in array) {
        if ([item.name isEqualToString:@"abilityName"]) {
            abilityName = item.value;
        } else if ([item.name isEqualToString:@"params"]) {
            params = item.value;
        }
    }

    [self handleOpenUrlWithBundleName:bundleName
                           moduleName:moduleName
                          abilityName:abilityName
                               params:params, nil];
    
    return YES;
}

- (BOOL)handleOpenUrlWithBundleName:(NSString *)bundleName
                         moduleName:(NSString *)moduleName
                        abilityName:(NSString *)abilityName
                             params:(NSString *)params, ...NS_REQUIRES_NIL_TERMINATION {
    
    id rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    BOOL hasRoot = NO;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        hasRoot = YES;
    }
    
    id subStageVC = nil;
    
    if ([moduleName isEqualToString:@"entry"] && [abilityName isEqualToString:@"EntryAbility"]) {
        NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",bundleName, moduleName, abilityName];
        EntryEntryAbilityViewController *entryOtherVC = [[EntryEntryAbilityViewController alloc] initWithInstanceName:instanceName];
        entryOtherVC.params = params;
        subStageVC = (EntryEntryAbilityViewController *)entryOtherVC;
    } // other ViewController
    
    if (!subStageVC) {
        return NO;
    }
    
    if (!hasRoot) {
        [self setNavRootVC:subStageVC];
    } else {
        UINavigationController *rootNav = (UINavigationController *)self.window.rootViewController;
        [rootNav pushViewController:subStageVC animated:YES];
    }
    return YES;
}

- (void)setNavRootVC:(id)viewController {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self setNaviAppearance:navi];
    self.window.rootViewController = navi;
}

- (void)setNaviAppearance:(UINavigationController *)navi {
    UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = UIColor.whiteColor;
    navi.navigationBar.standardAppearance = appearance;
    navi.navigationBar.scrollEdgeAppearance = navi.navigationBar.standardAppearance;
}

@end
