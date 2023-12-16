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

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger xcPageNo;//相册分类的页数：图片、截屏、视频的pageNo
@property (nonatomic, assign) NSInteger page3dNo;
@property (nonatomic, assign) NSInteger page7dNo;
@property (nonatomic, assign) NSInteger page30dNo;

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageNextSize;


// 获取所有的图片和视频，分类但不分页
- (void)getImagesAndVideos;

// 分页获取相册资源：所有图片、视频
- (void)initAlbumRes;

- (void)getNextPageData;

- (void)get3dAlbumResByPage;

- (void)get3dNextPageAlbumData;

- (void)get7dAlbumResByPage;

- (void)get7dNextPageAlbumData;

- (void)get30dAlbumResByPage;

- (void)get30dNextPageAlbumData;

// 图片
- (void)getPhotosByPage;

- (void)getNextPageAlbumPhotos;

// 截屏
- (void)getScreenshotsByPage;

- (void)getNextPageAlbumScreenshots;

// 视频
- (void)getVideosByPage;

- (void)getNextPageAlbumVideos;

// 视频
- (void)resetXcPageNo;

@end

