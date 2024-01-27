import router from '@ohos.router';
import Constants from '../common/constants/Constants';
import AlbumTabPage from './AlbumTabPage';
import PhotoItem from '../view/PhotoItem';
import VideoItem from '../view/VideoItem';
import { checkIsVideo, checkIsScreenshot } from '../common/utils/util.js';
import MyDataSource from '../bean/MyDataSource';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import emitter from '@ohos.events.emitter';
import promptAction from '@ohos.promptAction';

PersistentStorage.persistProp('currentPage', 'listPage');
PersistentStorage.persistProp('homeTabBottomIndex', 0); //tab index at bottom of home page
PersistentStorage.persistProp('homeTabIndex', 0); //Gallery tab tab switches index
PersistentStorage.persistProp('selectedIndex', 0); //index selected on the Details list page

interface albumFace {
  name: string,
  cnName: string,
  albumArr: string[]
}

export interface albumResFace {
  uri: string,
  createTime: number
}

export interface albumTypeRes {
  photos: string[],
  photosSize: number,
  screenshots: string[],
  screenshotsSize: number,
  videos: string[],
  videosSize: number
}

@Entry
@Component
struct Index {
  @State albumArr: Array<albumFace> = [];
  @State albumTypeResArr: albumTypeRes = {
    photos: [],
    photosSize: 0,
    screenshots: [],
    screenshotsSize: 0,
    videos: [],
    videosSize: 0
  };
  @State barHeight: number = Constants.TAB_BAR_HEIGHT;
  @State homeAlbumRes: MyDataSource = new MyDataSource(); // All resources in the gallery tab: pictures, screenshots, videos
  @State home3dAlbumRes: MyDataSource = new MyDataSource(); // 3 days of resources in the Gallery tab: pictures, screenshots, videos
  @State home7dAlbumRes: MyDataSource = new MyDataSource(); // 7 days of resources in the Gallery tab: pictures, screenshots, videos
  @State home30dAlbumRes: MyDataSource = new MyDataSource(); // 30 days of resources in the Gallery tab: pictures, screenshots, videos
  @State xcAlbumRes: MyDataSource = new MyDataSource(); // All resources in Album tab: pictures, screenshots, videos
  @State photoArr: MyDataSource = new MyDataSource(); // Gallery tab page with all the data Arr
  @State photo3dArr: MyDataSource = new MyDataSource(); // Arr for 3 days of data in the gallery tab page
  @State photo7dArr: MyDataSource = new MyDataSource(); // Arr for 7 days of data in the gallery tab page
  @State photo30dArr: MyDataSource = new MyDataSource(); // Arr for 30 days of data in the gallery tab page
  @State typeAlbumArr: MyDataSource = new MyDataSource(); // Data Arr in album tab page
  @State staticPhotoArr: MyDataSource = new MyDataSource();
  @State videoArr: MyDataSource = new MyDataSource();
  @State screenshotArr: MyDataSource = new MyDataSource();
  @State smallPhotoArr: MyDataSource = new MyDataSource();
  @State setStorage: boolean = false;
  @StorageLink('currentPage') @Watch('currentPageChange') currentPage: string = 'listPage';
  @StorageLink('lastPageCount') lastPageCount: number = 30;
  @StorageLink('isPageLoading') isPageLoading: boolean = false;
  @StorageLink('homeTabBottomIndex') homeTabBottomIndex: number = 0;
  @StorageLink('homeTabIndex') homeTabIndex: number = 0;
  @StorageLink('receivedAlbumRes') receivedAlbumRes: albumResFace[] = [];
  @StorageLink('currentListName') currentListName: string = 'home';
  private tabsController: TabsController = new TabsController();
  private pageNo: number = 1;
  private page3dNo: number = 1;
  private page7dNo: number = 1;
  private page30dNo: number = 1;
  private xcPageNo: number = 1;
  private pageSize: number = 30;

  aboutToAppear() {
    this.getUserPermission();
    this.receivedAlbumRes = [];
    let _this = this;
    // Drop down to load the next page event listener
    let innerEvent: emitter.InnerEvent = {
      eventId: Constants.ALBUM_EVENT_ID
    };
    emitter.on(innerEvent, (res) => {
      if (_this.currentListName === 'home') {
        if (this.homeTabIndex === 0) {
          _this.pageNo += 1;
        }
        if (this.homeTabIndex === 1) {
          _this.page3dNo += 1;
        }
        if (this.homeTabIndex === 2) {
          _this.page7dNo += 1;
        }
        if (this.homeTabIndex === 3) {
          _this.page30dNo += 1;
        }
      } else {
        _this.xcPageNo += 1;
      }
      _this.getCameraObjectRes(res?.data?.type);
    });
    // Initialized to obtain the latest 3 days, 7 days, and 1 month event listening
    let innerEvent2: emitter.InnerEvent = {
      eventId: Constants.RECENT_TIME_TYPE_ID
    };
    emitter.on(innerEvent2, (res) => {
      console.log('RECENT_TIME_TYPE_ID');
      _this.getCameraObjectRes(res?.data?.type);
    });
    AppStorage.setOrCreate('photoArr', this.photoArr);
    AppStorage.setOrCreate('photo3dArr', this.photo3dArr);
    AppStorage.setOrCreate('photo7dArr', this.photo7dArr);
    AppStorage.setOrCreate('photo30dArr', this.photo30dArr);
  }

  // Apply for user rights
  getUserPermission() {
    let list: Array<Permissions> = ['ohos.permission.READ_IMAGEVIDEO', 'ohos.permission.WRITE_IMAGEVIDEO'];
    let atManager = abilityAccessCtrl.createAtManager();
    let context: Context = AppStorage.get('context') as Context;
    atManager.requestPermissionsFromUser(context, list, (err, result) => {
      if (err) {
        promptAction.showToast({ message: '授权失败，请稍后重试' });
      } else {
        this.getCameraObjectRes();
      }
    });
  }

  currentPageChange() {
    if (this.currentPage === 'listPage') {
      this.barHeight = Constants.TAB_BAR_HEIGHT;
    } else {
      this.barHeight = 0;
    }
  }

  onBackPress() {
    if (this.currentPage === 'detailListPage' || this.currentPage === 'detailPage' || this.currentPage === 'videoDetailPage') {
      this.currentPage = 'listPage';
      return true;
    }
    return false;
  }

  // Gets media resources in an album
  async getCameraObjectRes(type?: string) {
    // The phAccessHelper instance obtained here is a global object, which is used in subsequent documents by default. If this piece of code is not added and an undefined error is reported, please add it yourself.
    let context: Context = AppStorage.get('context') as Context;
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
    let predicates = new dataSharePredicates.DataSharePredicates();
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [photoAccessHelper.PhotoKeys.DATE_ADDED],
      predicates: predicates
    };

    let receiveAlbumRes: albumResFace[] = [];
    // Assemble album tab column data
    let photos: albumResFace[] = [];
    let screenshots: albumResFace[] = [];
    let videos: albumResFace[] = [];

    try {
      // Pictures and videos in camera
      let albumCameraFetchResult = await phAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, photoAccessHelper.AlbumSubtype.CAMERA);
      let album = await albumCameraFetchResult.getFirstObject();
      let cameraFetchResult = await album.getAssets(fetchOptions);
      let cameraAllAsset = await cameraFetchResult.getAllObjects();
      cameraAllAsset.forEach((item) => {
        let createTime: photoAccessHelper.PhotoKeys = photoAccessHelper.PhotoKeys.DATE_ADDED;
        let assetsCreateTime: photoAccessHelper.MemberType = item.get(createTime.toString());
        receiveAlbumRes.push({
          uri: item.uri,
          createTime: assetsCreateTime as number
        });
      });
      cameraFetchResult.close();
      albumCameraFetchResult.close();
      // screenshot in the picture
      let albumsScreenshotFetchResult = await phAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, photoAccessHelper.AlbumSubtype.SCREENSHOT);
      let albumScreenshot = await albumsScreenshotFetchResult.getFirstObject();
      let screenshotFetchResult = await albumScreenshot.getAssets(fetchOptions);
      let screenshotAllAsset = await screenshotFetchResult.getAllObjects();
      screenshotAllAsset.forEach((item) => {
        let createTime: photoAccessHelper.PhotoKeys = photoAccessHelper.PhotoKeys.DATE_ADDED;
        let assetsCreateTime: photoAccessHelper.MemberType = item.get(createTime.toString());
        console.info('photoAsset Get assetsCreateTime = ', assetsCreateTime);
        receiveAlbumRes.push({
          uri: item.uri,
          createTime: assetsCreateTime as number
        });
        screenshots.push({
          uri: item.uri,
          createTime: assetsCreateTime as number
        });
      });
      screenshotFetchResult.close();
      albumsScreenshotFetchResult.close();
      // Arrange in reverse chronological order
      receiveAlbumRes.sort((a, b) => b.createTime - a.createTime);
      receiveAlbumRes.forEach((item) => {
        if (checkIsVideo(item.uri)) {
          videos.push(item);
        } else {
          photos.push(item);
        }
      });
      this.albumTypeResArr = {
        photos: photos.length > 0 ? [photos[0].uri] : [],
        photosSize: photos.length,
        screenshots: screenshots.length > 0 ? [screenshots[0].uri] : [],
        screenshotsSize: screenshots.length,
        videos: videos.length > 0 ? [videos[0].uri] : [],
        videosSize: videos.length
      };
      let pageNo = this.pageNo;
      let finalAlbumRes = receiveAlbumRes;
      // Add 3 days, 7 days, and a month of data filtering here,pageNo
      if (this.homeTabIndex === 1) {
        pageNo = this.page3dNo;
        finalAlbumRes = this.filterDataByTime(receiveAlbumRes, 3);
      }
      if (this.homeTabIndex === 2) {
        pageNo = this.page7dNo;
        finalAlbumRes = this.filterDataByTime(receiveAlbumRes, 7);
      }
      if (this.homeTabIndex === 3) {
        pageNo = this.page30dNo;
        finalAlbumRes = this.filterDataByTime(receiveAlbumRes, 30);
      }
      if (type === 'photos') {
        pageNo = this.xcPageNo;
        finalAlbumRes = photos;
      }
      if (type === 'screenshots') {
        pageNo = this.xcPageNo;
        finalAlbumRes = screenshots;
      }
      if (type === 'videos') {
        pageNo = this.xcPageNo;
        finalAlbumRes = videos;
      }
      let startIndex = (pageNo - 1) * this.pageSize; // Calculates the index position of the resource displayed at the beginning of the page
      let endIndex = Math.min(startIndex + this.pageSize, finalAlbumRes.length); // Calculate the index location of the resources displayed at the end of the page to ensure that the total number of resources is not exceeded
      let pageRes = new Array<albumResFace>();
      if (startIndex < endIndex) {
        pageRes = this.getPaginatedData(finalAlbumRes, pageNo, this.pageSize);
      }
      this.lastPageCount = pageRes.length;
      this.isPageLoading = false;
      let albumRes: Array<string> = [];
      if (this.currentListName === 'home') {
        if (this.homeTabIndex === 0) {
          albumRes = JSON.parse(JSON.stringify(this.homeAlbumRes.getAllData()))
        }
        if (this.homeTabIndex === 1) {
          albumRes = JSON.parse(JSON.stringify(this.home3dAlbumRes.getAllData()))
        }
        if (this.homeTabIndex === 2) {
          albumRes = JSON.parse(JSON.stringify(this.home7dAlbumRes.getAllData()))
        }
        if (this.homeTabIndex === 3) {
          albumRes = JSON.parse(JSON.stringify(this.home30dAlbumRes.getAllData()))
        }
      } else {
        albumRes = JSON.parse(JSON.stringify(this.xcAlbumRes.getAllData()))
      }
      pageRes.forEach((item: albumResFace) => {
        albumRes.push(item.uri);
      });
      this.handleStorageAlbum(albumRes, pageRes);
    } catch (err) {
      console.error('camera album failed with err: ' + err);
    }
  }

  // Filter the data
  filterDataByTime(receiveAlbumRes: albumResFace[], days: number) {
    let timestamp: number = Math.floor(new Date().getTime() / 1000) - (24 * 60 * 60) * days;
    let recentDayRes: albumResFace[] = [];
    receiveAlbumRes.forEach((item) => {
      if (item.createTime >= timestamp) {
        recentDayRes.push(item);
      }
    });
    return recentDayRes;
  }

  getPaginatedData(array: albumResFace[], pageNo: number, pageSize: number): albumResFace[] {
    let startIndex = (pageNo - 1) * pageSize;
    let endIndex = Math.min(startIndex + pageSize, array.length);
    return array.slice(startIndex, endIndex);
  }

  // Process and store album resources
  handleStorageAlbum(albumRes: Array<string>, receivedAlbumRes: albumResFace[]) {
    let videoArr: Array<string> = [];
    let photoArr: Array<string> = [];
    let screenshotArr: Array<string> = [];
    albumRes.forEach((item: string) => {
      if (checkIsVideo(item)) {
        videoArr.push(item);
      } else {
        photoArr.push(item);
      }
    });
    photoArr.forEach((item: string) => {
      if (checkIsScreenshot(item)) {
        screenshotArr.push(item);
      }
    });
    if (this.currentListName === 'home') {
      if (this.homeTabIndex === 0) { //所有
        this.photoArr.reloadData(JSON.parse(JSON.stringify(albumRes)));
        this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST, this.photoArr.getAllData(), Constants.CACHE_IMG_LIST));
        this.homeAlbumRes.reloadData(JSON.parse(JSON.stringify(albumRes)));
        AppStorage.setOrCreate('photoArr', this.photoArr);
      }
      if (this.homeTabIndex === 1) { //近3天
        this.photo3dArr.reloadData(JSON.parse(JSON.stringify(albumRes)));
        this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST, this.photo3dArr.getAllData(), Constants.CACHE_IMG_LIST));
        this.home3dAlbumRes.reloadData(JSON.parse(JSON.stringify(albumRes)));
        AppStorage.setOrCreate('photo3dArr', this.photo3dArr);
        AppStorage.setOrCreate('photoArr', this.photo3dArr);
      }
      if (this.homeTabIndex === 2) { //近7天
        this.photo7dArr.reloadData(JSON.parse(JSON.stringify(albumRes)));
        this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST, this.photo7dArr.getAllData(), Constants.CACHE_IMG_LIST));
        this.home7dAlbumRes.reloadData(JSON.parse(JSON.stringify(albumRes)));
        AppStorage.setOrCreate('photo7dArr', this.photo7dArr);
        AppStorage.setOrCreate('photoArr', this.photo7dArr);
      }
      if (this.homeTabIndex === 3) { //近1个月
        this.photo30dArr.reloadData(JSON.parse(JSON.stringify(albumRes)));
        this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST, this.photo30dArr.getAllData(), Constants.CACHE_IMG_LIST));
        this.home30dAlbumRes.reloadData(JSON.parse(JSON.stringify(albumRes)));
        AppStorage.setOrCreate('photo30dArr', this.photo30dArr);
        AppStorage.setOrCreate('photo7dArr', this.photo30dArr);
      }
      this.receivedAlbumRes = this.receivedAlbumRes.concat(receivedAlbumRes);
      AppStorage.setOrCreate('receivedAlbumRes', this.receivedAlbumRes);

    } else {
      this.typeAlbumArr.reloadData(JSON.parse(JSON.stringify(albumRes)));
      this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST, this.typeAlbumArr.getAllData(), Constants.CACHE_IMG_LIST));
      this.xcAlbumRes.reloadData(JSON.parse(JSON.stringify(albumRes)));
      AppStorage.setOrCreate('typeAlbumArr', this.typeAlbumArr);
      AppStorage.setOrCreate('xcAlbumRes', this.xcAlbumRes);
    }
    this.videoArr.reloadData(videoArr);
    this.screenshotArr.reloadData(screenshotArr);
    AppStorage.setOrCreate('smallPhotoArr', this.smallPhotoArr);
    AppStorage.setOrCreate('videoArr', this.videoArr);
    AppStorage.setOrCreate('screenshotArr', this.screenshotArr);
    AppStorage.setOrCreate('lastPageCount', this.lastPageCount);
    this.setStorage = true;
    this.handleChangeTab();
  }

  // Reset storage and go to a different album category
  async resetEnterDiffPage(item: albumFace) {
    this.xcAlbumRes.reloadData([]);
    this.typeAlbumArr.reloadData([]);
    this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST, [], Constants.CACHE_IMG_LIST));
    AppStorage.setOrCreate('typeAlbumArr', this.typeAlbumArr);
    AppStorage.setOrCreate('xcAlbumRes', this.xcAlbumRes);
    this.xcPageNo = 1;
    if (item.name === 'photos') {
      this.getCameraObjectRes('photos');
      AppStorage.setOrCreate('photoArr', this.typeAlbumArr);
    }
    if (item.name === 'screenshots') {
      this.getCameraObjectRes('screenshots');
      AppStorage.setOrCreate('photoArr', this.typeAlbumArr);
    }
    if (item.name === 'videos') {
      this.getCameraObjectRes('videos');
    }
    this.currentListName = item.name;
    AppStorage.setOrCreate('currentListName', this.currentListName);
    router.pushUrl({
      url: Constants.URL_ALBUM_REDIRECT_PAGE
    });
  }

  //Toggle Bottom tab
  handleChangeTab() {
    if (this.homeTabBottomIndex == 1) {
      this.albumArr = [];
      if (this.albumTypeResArr.photosSize > 0) {
        this.albumArr.push({
          name: 'photos',
          cnName: '图片',
          albumArr: this.albumTypeResArr.photos
        })
      }
      if (this.albumTypeResArr.screenshotsSize > 0) {
        this.albumArr.push({
          name: 'screenshots',
          cnName: '截屏',
          albumArr: this.albumTypeResArr.screenshots
        })
      }
      if (this.albumTypeResArr.videosSize > 0) {
        this.albumArr.push({
          name: 'videos',
          cnName: '视频',
          albumArr: this.albumTypeResArr.videos
        })
      }
    }
  }

  /**
   * Gallery content
   * Include: CAMERA + SCREENSHOT + VIDEO
   */
  @Builder
  TkContentBuilder() {
    if (this.setStorage) {
      AlbumTabPage({
        currentPage: this.currentPage,
        lastPageCount: this.lastPageCount,
        isPageLoading: this.isPageLoading,
        barHeight: this.barHeight
      })
    } else {
      Image($r('app.media.default_img'))
        .width(200)
        .height(200)
    }
  }

  /**
   * Album content
   * Included: CAMERA + SCREENSHOT (picture), SCREENSHOT (screenshot), VIDEO (video), TRASH can (additional requirements)
   */
  @Builder
  XcContentBuilder() {
    if (this.setStorage) {
      Grid() {
        ForEach(this.albumArr, (item: albumFace) => {
          GridItem() {
            Column() {
              if (item.name !== 'videos') {
                PhotoItem({ photoArr: item.albumArr })
              } else {
                VideoItem({ photoArr: item.albumArr })
              }
              Text(item.cnName).fontSize(16).width('100%').textAlign(TextAlign.Center)
            }
          }
          .width(Constants.FULL_PERCENT)
          .aspectRatio(Constants.STACK_IMG_RATIO)
          .onClick(() => {
            this.resetEnterDiffPage(item);
          })
        }, (item: albumFace, index?: number) => JSON.stringify(item) + index)
      }
      .columnsTemplate(Constants.INDEX_COLUMNS_TEMPLATE)
      .columnsGap($r('app.float.grid_padding'))
      .rowsGap($r('app.float.grid_padding'))
      .padding({
        left: $r('app.float.grid_padding'),
        right: $r('app.float.grid_padding'),
        top: $r('app.float.grid_padding')
      })
      .width(Constants.FULL_PERCENT)
      .layoutWeight(1)
    } else {
      Image($r('app.media.default_img'))
        .width(200)
        .height(200)
    }
  }

  // Bottom button style
  @Builder
  TabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.homeTabBottomIndex === targetIndex ? '#1698CE' : '#6B6B6B')
    }
    .onClick(() => {
      this.homeTabBottomIndex = targetIndex;
      this.tabsController.changeIndex(this.homeTabBottomIndex);
    })
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController, index: this.homeTabBottomIndex }) {
      TabContent() {
        this.TkContentBuilder()
      }.tabBar(this.TabBuilder('图库', 0))

      TabContent() {
        this.XcContentBuilder()
      }
      .tabBar(this.TabBuilder('相册', 1))
    }
    .barHeight(this.barHeight)
    .scrollable(false)
    .onChange((index) => {
      this.homeTabBottomIndex = index;
      this.handleChangeTab();
    })
  }
}