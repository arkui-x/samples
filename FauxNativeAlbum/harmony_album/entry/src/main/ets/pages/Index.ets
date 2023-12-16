import router from '@ohos.router';
import Constants from '../common/constants/Constants';
import AlbumTabPage from './AlbumTabPage';
import PhotoItem from '../view/PhotoItem';
import VideoItem from '../view/VideoItem';
import { checkIsVideo,checkIsScreenshot } from '../common/utils/util.js';
import MyDataSource from '../bean/MyDataSource';
import abilityAccessCtrl, {Permissions} from '@ohos.abilityAccessCtrl';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import emitter from '@ohos.events.emitter';
import promptAction from '@ohos.promptAction';

PersistentStorage.persistProp('currentPage','listPage');
PersistentStorage.persistProp('homeTabBottomIndex',0);//首页底部tab index
PersistentStorage.persistProp('homeTabIndex',0);//图库tab页 tab 切换index
PersistentStorage.persistProp('selectedIndex',0);//详情列表页选中的index


//album类型接口
interface albumFace {
  name:string,
  cnName:string,
  albumArr:string[]
}

//albumRes类型接口
export interface albumResFace {
  uri:string,
  createTime:number
}

//albumTypeRes 相册所有资源分类接口
export interface albumTypeRes {
  photos:string[],
  photosSize:number,
  screenshots:string[],
  screenshotsSize:number,
  videos:string[],
  videosSize:number
}

@Entry
@Component
struct Index {
  @State albumArr: Array<albumFace> = [];
  @State albumTypeResArr: albumTypeRes = { photos:[],photosSize:0,screenshots:[],screenshotsSize:0,videos:[],videosSize:0 };
  @State barHeight:number = Constants.TAB_BAR_HEIGHT;
  @State homeAlbumRes: MyDataSource = new MyDataSource();// 图库tab中的所有资源：图片、截图、视频
  @State home3dAlbumRes: MyDataSource = new MyDataSource();// 图库tab中的3天资源：图片、截图、视频
  @State home7dAlbumRes: MyDataSource = new MyDataSource();// 图库tab中的7天资源：图片、截图、视频
  @State home30dAlbumRes: MyDataSource = new MyDataSource();// 图库tab中的30天资源：图片、截图、视频
  @State xcAlbumRes: MyDataSource = new MyDataSource();// 相册tab中的所有资源：图片、截图、视频
  @State photoArr: MyDataSource = new MyDataSource();// 图库tab页内的所有的数据Arr
  @State photo3dArr: MyDataSource = new MyDataSource();// 图库tab页内的3天的数据Arr
  @State photo7dArr: MyDataSource = new MyDataSource();// 图库tab页内的7天的数据Arr
  @State photo30dArr: MyDataSource = new MyDataSource();// 图库tab页内的30天数据Arr
  @State typeAlbumArr: MyDataSource = new MyDataSource();// 相册tab页内的数据Arr
  @State staticPhotoArr: MyDataSource = new MyDataSource();//不会改变的图片数组
  @State videoArr: MyDataSource = new MyDataSource();// 相册中的所有视频
  @State screenshotArr: MyDataSource = new MyDataSource();// 相册中的截图
  @State smallPhotoArr: MyDataSource = new MyDataSource();//详情列表页的小图列表
  @State setStorage:boolean = false;
  @StorageLink('currentPage') @Watch('currentPageChange') currentPage:string = 'listPage';
  @StorageLink('lastPageCount') lastPageCount:number = 30;//最后一页的数量
  @StorageLink('isPageLoading') isPageLoading:boolean = false;//是否在请求下一页
  @StorageLink('homeTabBottomIndex') homeTabBottomIndex: number = 0;//tab切换index
  @StorageLink('homeTabIndex') homeTabIndex: number = 0;//图库tab页 tab 切换index
  @StorageLink('receivedAlbumRes') receivedAlbumRes: albumResFace[] = [];
  @StorageLink('currentListName') currentListName: string = 'home';
  private tabsController:TabsController = new TabsController();
  private pageNo:number = 1;//图库tab pageNo
  private page3dNo:number = 1;//首页近3天tab的pageNo
  private page7dNo:number = 1;//首页近7天tab的pageNo
  private page30dNo:number = 1;//首页近30天tab的pageNo
  private xcPageNo:number = 1;//相册tab pageNo
  private pageSize:number = 30;

  aboutToAppear() {
    this.getUserPermission();
    this.receivedAlbumRes = [];
    let _this = this;
    // 下拉加载下一页事件监听
    let innerEvent: emitter.InnerEvent = {
      eventId: Constants.ALBUM_EVENT_ID
    };
    emitter.on(innerEvent, (res) => {
      if(_this.currentListName === 'home') {
        if(this.homeTabIndex === 0) {//所有
          _this.pageNo += 1;
        }
        if(this.homeTabIndex === 1) {//近3天
          _this.page3dNo += 1;
        }
        if(this.homeTabIndex === 2) {//近7天
          _this.page7dNo += 1;
        }
        if(this.homeTabIndex === 3) {//近30天
          _this.page30dNo += 1;
        }
      }else {
        _this.xcPageNo += 1;
      }
      _this.getCameraObjectRes(res?.data?.type);
    })                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ;
    // 初始化获取最近3天、7天、一个月事件监听
    let innerEvent2: emitter.InnerEvent = {
      eventId: Constants.RECENT_TIME_TYPE_ID
    };
    emitter.on(innerEvent2, (res) => {
      console.log('RECENT_TIME_TYPE_ID');
      _this.getCameraObjectRes(res?.data?.type);
    });

    AppStorage.setOrCreate('photoArr',this.photoArr);
    AppStorage.setOrCreate('photo3dArr',this.photo3dArr);
    AppStorage.setOrCreate('photo7dArr',this.photo7dArr);
    AppStorage.setOrCreate('photo30dArr',this.photo30dArr);
  }

  // 像用户申请用户权限
  getUserPermission() {
    let list : Array<Permissions> = ['ohos.permission.READ_IMAGEVIDEO', 'ohos.permission.WRITE_IMAGEVIDEO'];
    let atManager = abilityAccessCtrl.createAtManager();
    let context:Context = AppStorage.get('context') as Context;
    atManager.requestPermissionsFromUser(context, list, (err, result) => {
      if (err) {
        promptAction.showToast({ message: '授权失败，请稍后重试' });
      } else {
        this.getCameraObjectRes();
      }
    });
  }

  currentPageChange() {
    if(this.currentPage === 'listPage') {
      this.barHeight = Constants.TAB_BAR_HEIGHT;
    }else {
      this.barHeight = 0;
    }
  }

  onBackPress() {
    if(this.currentPage === 'detailListPage' || this.currentPage === 'detailPage' || this.currentPage === 'videoDetailPage') {
      this.currentPage = 'listPage';
      return true;
    }
    return false;
  }

  // 获取相册中的媒体资源
  async getCameraObjectRes(type?:string) {
    // 此处获取的phAccessHelper实例为全局对象，后续文档中使用到的地方默认为使用此处获取的对象，如未添加此段代码报未定义的错误请自行添加。
    let context:Context = AppStorage.get('context') as Context;
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
    let predicates = new dataSharePredicates.DataSharePredicates();
    let fetchOptions:photoAccessHelper.FetchOptions = {
      fetchColumns: [photoAccessHelper.PhotoKeys.DATE_ADDED],
      predicates: predicates
    };

    let receiveAlbumRes:albumResFace[] = [];
    // 组装相册tab栏目的数据
    let photos:albumResFace[] = [];
    let screenshots:albumResFace[] = [];
    let videos:albumResFace[] = [];

    try {
      // camera里的图片、视频
      let albumCameraFetchResult = await phAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, photoAccessHelper.AlbumSubtype.CAMERA);
      let album = await albumCameraFetchResult.getFirstObject();
      let cameraFetchResult = await album.getAssets(fetchOptions);
      let cameraAllAsset = await cameraFetchResult.getAllObjects();
      cameraAllAsset.forEach((item) => {
        let createTime: photoAccessHelper.PhotoKeys = photoAccessHelper.PhotoKeys.DATE_ADDED;
        let assetsCreateTime: photoAccessHelper.MemberType = item.get(createTime.toString());
        receiveAlbumRes.push({
          uri:item.uri,
          createTime:assetsCreateTime as number
        });
      });

      cameraFetchResult.close();
      albumCameraFetchResult.close();

      // screenshot里的图片
      let albumsScreenshotFetchResult = await phAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, photoAccessHelper.AlbumSubtype.SCREENSHOT);
      let albumScreenshot = await albumsScreenshotFetchResult.getFirstObject();
      let screenshotFetchResult = await albumScreenshot.getAssets(fetchOptions);
      let screenshotAllAsset = await screenshotFetchResult.getAllObjects();
      screenshotAllAsset.forEach((item) => {
        let createTime: photoAccessHelper.PhotoKeys = photoAccessHelper.PhotoKeys.DATE_ADDED;
        let assetsCreateTime: photoAccessHelper.MemberType = item.get(createTime.toString());
        console.info('photoAsset Get assetsCreateTime = ', assetsCreateTime);
        receiveAlbumRes.push({
          uri:item.uri,
          createTime:assetsCreateTime as number
        });
        screenshots.push({
          uri:item.uri,
          createTime:assetsCreateTime as number
        });
      });

      screenshotFetchResult.close();
      albumsScreenshotFetchResult.close();

      // 按时间进行倒叙排列
      receiveAlbumRes.sort((a, b) => b.createTime - a.createTime);

      receiveAlbumRes.forEach((item) => {
        if(checkIsVideo(item.uri)) {
          videos.push(item);
        }else {
          photos.push(item);
        }
      });
      this.albumTypeResArr = {
        photos:photos.length > 0 ? [photos[0].uri] : [],
        photosSize:photos.length,
        screenshots:screenshots.length > 0 ? [screenshots[0].uri] : [],
        screenshotsSize:screenshots.length,
        videos:videos.length > 0 ? [videos[0].uri] : [],
        videosSize:videos.length
      };

      let pageNo = this.pageNo;
      let finalAlbumRes = receiveAlbumRes;
      // 这里增加3天、7天、一个月的数据筛选,pageNo
      if(this.homeTabIndex === 1) {//近3天
        pageNo = this.page3dNo;
        finalAlbumRes = this.filterDataByTime(receiveAlbumRes, 3);
      }
      if(this.homeTabIndex === 2) {//近7天
        pageNo = this.page7dNo;
        finalAlbumRes = this.filterDataByTime(receiveAlbumRes, 7);
      }
      if(this.homeTabIndex === 3) {//近30天
        pageNo = this.page30dNo;
        finalAlbumRes = this.filterDataByTime(receiveAlbumRes, 30);
      }

      console.log('finalAlbumRes：' + finalAlbumRes);

      if(type === 'photos') {
        pageNo = this.xcPageNo;
        finalAlbumRes = photos;
        console.log('getCameraObjectRes type is photos');
      }
      if(type === 'screenshots') {
        pageNo = this.xcPageNo;
        finalAlbumRes = screenshots;
        console.log('getCameraObjectRes type is screenshots');
      }
      if(type === 'videos') {
        pageNo = this.xcPageNo;
        finalAlbumRes = videos;
        console.log('getCameraObjectRes type is videos');
      }

      let startIndex = (pageNo - 1) * this.pageSize; // 计算这一页开始显示的资源的索引位置
      let endIndex = Math.min(startIndex + this.pageSize, finalAlbumRes.length); // 计算这一页结束显示的资源的索引位置，确保不会超过资源总数
      let pageRes = new Array<albumResFace>();
      if(startIndex < endIndex) {
        pageRes = this.getPaginatedData(finalAlbumRes,pageNo,this.pageSize);
      }

      this.lastPageCount = pageRes.length;
      this.isPageLoading = false;

      let albumRes: Array<string> = [];

      if(this.currentListName === 'home') {
        if(this.homeTabIndex === 0) {//所有
          albumRes = JSON.parse(JSON.stringify(this.homeAlbumRes.getAllData()))
        }
        if(this.homeTabIndex === 1) {//近3天
          albumRes = JSON.parse(JSON.stringify(this.home3dAlbumRes.getAllData()))
        }
        if(this.homeTabIndex === 2) {//近7天
          albumRes = JSON.parse(JSON.stringify(this.home7dAlbumRes.getAllData()))
        }
        if(this.homeTabIndex === 3) {//近30天
          albumRes = JSON.parse(JSON.stringify(this.home30dAlbumRes.getAllData()))
        }
      } else {
        albumRes = JSON.parse(JSON.stringify(this.xcAlbumRes.getAllData()))
      }
      pageRes.forEach((item:albumResFace) => {
        albumRes.push(item.uri);
      });

      console.log('this.receivedAlbumRes.pageRes:' + pageRes.length);
      console.log('this.receivedAlbumRes.homeTabIndex:' + this.homeTabIndex);

      this.handleStorageAlbum(albumRes,pageRes);

    } catch (err) {
      console.error('camera album failed with err: ' + err);
    }
  }

  // 对数据进行筛选
  filterDataByTime(receiveAlbumRes:albumResFace[], days:number) {
    let timestamp:number = Math.floor(new Date().getTime()/1000) - (24 * 60 * 60 * 1000) * days;//day天前的时间戳
    let recentDayRes:albumResFace[] = [];
    receiveAlbumRes.forEach((item) => {
      if(item.createTime >= timestamp) {
        recentDayRes.push(item);
      }
    });
    return recentDayRes;
  }

  getPaginatedData(array:albumResFace[], pageNo:number, pageSize:number):albumResFace[] {
    let startIndex = (pageNo - 1) * pageSize;
    let endIndex = Math.min(startIndex + pageSize, array.length);
    return array.slice(startIndex, endIndex);
  }

  // 处理并存储相册资源
  async handleStorageAlbum(albumRes: Array<string>,receivedAlbumRes: albumResFace[]) {
    let videoArr:Array<string> = [];
    let photoArr:Array<string> = [];
    let screenshotArr:Array<string> = [];
    albumRes.forEach((item:string) => {
      if(checkIsVideo(item)) {
        videoArr.push(item);
      }else {
        photoArr.push(item);
      }
    });

    photoArr.forEach((item:string) => {
      if(checkIsScreenshot(item)) {
        screenshotArr.push(item);
      }
    });


    console.log('this.homeTabIndex:' + this.currentListName);
    if(this.currentListName === 'home') {
      console.log('this.homeTabIndex:===============================');
      console.log('this.homeTabIndex:===============================');
      console.log('this.homeTabIndex:' + this.homeTabIndex);
      if(this.homeTabIndex === 0) {//所有
        this.photoArr.reloadData(JSON.parse(JSON.stringify(albumRes)));
        this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST,this.photoArr.getAllData(),Constants.CACHE_IMG_LIST));
        this.homeAlbumRes.reloadData(JSON.parse(JSON.stringify(albumRes)));
        // homeTabAlbumRes = this.homeAlbumRes;
        await AppStorage.setOrCreate('photoArr',this.photoArr);
      }
      if(this.homeTabIndex === 1) {//近3天
        this.photo3dArr.reloadData(JSON.parse(JSON.stringify(albumRes)));
        this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST,this.photo3dArr.getAllData(),Constants.CACHE_IMG_LIST));
        this.home3dAlbumRes.reloadData(JSON.parse(JSON.stringify(albumRes)));
        // homeTabAlbumRes = this.home3dAlbumRes;
        await AppStorage.setOrCreate('photo3dArr',this.photo3dArr);
      }
      if(this.homeTabIndex === 2) {//近7天
        this.photo7dArr.reloadData(JSON.parse(JSON.stringify(albumRes)));
        this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST,this.photo7dArr.getAllData(),Constants.CACHE_IMG_LIST));
        this.home7dAlbumRes.reloadData(JSON.parse(JSON.stringify(albumRes)));
        // homeTabAlbumRes = this.home7dAlbumRes;
        await AppStorage.setOrCreate('photo7dArr',this.photo7dArr);
      }
      if(this.homeTabIndex === 3) {//近1个月
        this.photo30dArr.reloadData(JSON.parse(JSON.stringify(albumRes)));
        this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST,this.photo30dArr.getAllData(),Constants.CACHE_IMG_LIST));
        this.home30dAlbumRes.reloadData(JSON.parse(JSON.stringify(albumRes)));
        // homeTabAlbumRes = this.home30dAlbumRes;
        await AppStorage.setOrCreate('photo30dArr',this.photo30dArr);
      }

      this.receivedAlbumRes = this.receivedAlbumRes.concat(receivedAlbumRes);
      await AppStorage.setOrCreate('receivedAlbumRes',this.receivedAlbumRes);

    }else {
      this.typeAlbumArr.reloadData(JSON.parse(JSON.stringify(albumRes)));
      this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST,this.typeAlbumArr.getAllData(),Constants.CACHE_IMG_LIST));
      this.xcAlbumRes.reloadData(JSON.parse(JSON.stringify(albumRes)));

      await AppStorage.setOrCreate('typeAlbumArr',this.typeAlbumArr);
      await AppStorage.setOrCreate('xcAlbumRes',this.xcAlbumRes);
    }
    this.videoArr.reloadData(videoArr);
    this.screenshotArr.reloadData(screenshotArr);

    await AppStorage.setOrCreate('smallPhotoArr',this.smallPhotoArr);
    await AppStorage.setOrCreate('videoArr',this.videoArr);
    await AppStorage.setOrCreate('screenshotArr',this.screenshotArr);
    await AppStorage.setOrCreate('lastPageCount',this.lastPageCount);
    this.setStorage = true;
    this.handleChangeTab();
  }

  // 重置storage并进入不同的相册分类
  async resetEnterDiffPage(item:albumFace) {
    this.xcAlbumRes.reloadData([]);
    this.typeAlbumArr.reloadData([]);
    this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST,[],Constants.CACHE_IMG_LIST));
    await AppStorage.setOrCreate('typeAlbumArr',this.typeAlbumArr);
    await AppStorage.setOrCreate('xcAlbumRes',this.xcAlbumRes);

    this.xcPageNo = 1;
    if(item.name === 'photos') {
      this.getCameraObjectRes('photos');
    }
    if(item.name === 'screenshots') {
      this.getCameraObjectRes('screenshots');
    }
    if(item.name === 'videos') {
      this.getCameraObjectRes('videos');
    }
    this.currentListName = item.name;
    AppStorage.setOrCreate('currentListName',this.currentListName);
    router.pushUrl({
      url: Constants.URL_ALBUM_REDIRECT_PAGE
    });
  }

  //切换底部tab
  handleChangeTab() {
    if(this.homeTabBottomIndex == 1) { //点击相册
      this.albumArr = [];
      if(this.albumTypeResArr.photosSize > 0) {
        this.albumArr.push({
          name:'photos',
          cnName:'图片',
          albumArr:this.albumTypeResArr.photos
        })
      }
      if(this.albumTypeResArr.screenshotsSize > 0) {
        this.albumArr.push({
          name:'screenshots',
          cnName:'截屏',
          albumArr:this.albumTypeResArr.screenshots
        })
      }
      if(this.albumTypeResArr.videosSize > 0) {
        this.albumArr.push({
          name:'videos',
          cnName:'视频',
          albumArr:this.albumTypeResArr.videos
        })
      }
    }
  }

  /**
   * 图库内容
   * 包含：CAMERA  + SCREENSHOT（图片） + VIDEO（视频）
   */
  @Builder TkContentBuilder() {
    if(this.setStorage) {
      AlbumTabPage({
        currentPage:this.currentPage,
        lastPageCount:this.lastPageCount,
        isPageLoading:this.isPageLoading,
        barHeight:this.barHeight
      })
    }else {
      Image($r('app.media.default_img'))
        .width(200)
        .height(200)
    }
  }

  /**
   * 相册内容
   * 包含：CAMERA  + SCREENSHOT（图片）、SCREENSHOT（截屏录屏）、VIDEO（视频）、TRASH垃圾桶（额外需求）
   */
  @Builder XcContentBuilder() {
    if(this.setStorage) {
      Grid() {
        ForEach(this.albumArr, (item:albumFace) => {
          GridItem() {
            Column() {
              if(item.name !== 'videos') {
                PhotoItem({ photoArr:item.albumArr })
              }else {
                VideoItem({ photoArr:item.albumArr })
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
      .padding({ left: $r('app.float.grid_padding'), right: $r('app.float.grid_padding'),top: $r('app.float.grid_padding') })
      .width(Constants.FULL_PERCENT)
      .layoutWeight(1)
    }else {
      Image($r('app.media.default_img'))
        .width(200)
        .height(200)
    }
  }

  // 底部按钮样式
  @Builder TabBuilder(title: string, targetIndex: number) {
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
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController,index:this.homeTabBottomIndex }) {
      TabContent() {
        this.TkContentBuilder()
      }.tabBar(this.TabBuilder('图库',0))

      TabContent() {
        this.XcContentBuilder()
      }
      .tabBar(this.TabBuilder('相册',1))
    }
    .barHeight(this.barHeight)
    .scrollable(false)
    .onChange((index) => {
      this.homeTabBottomIndex = index;
      this.handleChangeTab();
    })
  }
}