import bridge from '@arkui-x.bridge';// 导入平台桥接模块
import router from '@ohos.router';
import Constants from '../common/constants/Constants';
import AlbumTabPage from './AlbumTabPage';
import PhotoItem from '../view/PhotoItem';
import VideoItem from '../view/VideoItem';
import { checkIsVideo,checkIsScreenshot } from '../common/utils/util.js';
import MyDataSource from '../bean/MyDataSource'

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

//this接口
interface thisFace {
  screenshotArr:MyDataSource,
  handleChangeTab:Function,
  isIOS:boolean,
  albumTypeResArr:albumTypeRes,
  typeAlbumArr:MyDataSource,
  smallPhotoArr:MyDataSource,
  xcAlbumRes:MyDataSource
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
  private bridgeImpl = bridge.createBridge('Bridge');// 创建平台桥接对象
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
  @State typeAlbumArr: MyDataSource = new MyDataSource();// 图库tab页内的数据Arr
  @State videoArr: MyDataSource = new MyDataSource();// 相册中的所有视频
  @State screenshotArr: MyDataSource = new MyDataSource();// 相册中的截图
  @State smallPhotoArr: MyDataSource = new MyDataSource();//详情列表页的小图列表
  @State setStorage:boolean = false;
  @State isIOS:boolean = false;
  @StorageLink('currentPage') @Watch('currentPageChange') currentPage:string = 'listPage';
  @StorageLink('lastPageCount') lastPageCount:number = 30;//最后一页的数量
  @StorageLink('isPageLoading') isPageLoading:boolean = false;//是否在请求下一页
  @StorageLink('homeTabBottomIndex') homeTabBottomIndex: number = 0;//tab切换index
  @StorageLink('homeTabIndex') homeTabIndex: number = 0;//图库tab页 tab 切换index
  @StorageLink('receivedAlbumRes') receivedAlbumRes: albumResFace[] = [];
  @StorageLink('currentListName') currentListName: string = 'home';
  private tabsController : TabsController = new TabsController();

  aboutToAppear() {
    this.listenAndroidIOS();
    AppStorage.setOrCreate('_this',this);
    this.bridgeImpl.registerMethod({ name: 'getImagesAndVideos', method: this.getImagesAndVideos });
    this.bridgeImpl.registerMethod({ name: 'getScreenInfo', method: this.getScreenInfo });
    this.bridgeImpl.registerMethod({ name: 'getIOSScreenshot', method: this.getIOSScreenshot });
    this.initAlbumData();
    AppStorage.setOrCreate('bridgeImpl',this.bridgeImpl);
    AppStorage.setOrCreate('photoArr',this.photoArr);
    AppStorage.setOrCreate('photo3dArr',this.photo3dArr);
    AppStorage.setOrCreate('photo7dArr',this.photo7dArr);
    AppStorage.setOrCreate('photo30dArr',this.photo30dArr);
  }

  currentPageChange() {
    if(this.currentPage === 'listPage') {
      this.barHeight = Constants.TAB_BAR_HEIGHT;
    }else {
      this.barHeight = 0;
    }
  }

  onBackPress() {
    console.log('this.currentPage:' + this.currentPage);
    if(this.currentPage === 'detailListPage' || this.currentPage === 'detailPage' || this.currentPage === 'videoDetailPage') {
      this.currentPage = 'listPage';
      return true;
    }
    return false;
  }

  initAlbumData() {
    // 获取原生应用的相册信息
    this.bridgeImpl.callMethod('getAlbumRes');
    // 获取原生应用的相册分页信息
    this.bridgeImpl.callMethod('getAlbumResByPage');
  }

  // 获取所有的图片和视频，分类但不分页
  getImagesAndVideos(parameters:Record<string , bridge.Parameter> | undefined) {
    try {
      let _this:thisFace = AppStorage.get('_this') as thisFace;
      console.log('getImagesAndVideos params:' + parameters);
      _this.albumTypeResArr = JSON.parse(String(parameters)) as albumTypeRes;
      _this.handleChangeTab();
    } catch (err) {
      console.log('err:' + JSON.stringify(err))
    }
    return 'call js getImagesAndVideos success';
  }

  getScreenInfo(parameters:Record<string , bridge.Parameter> | undefined) {
    console.log('getScreenInfo params:' + parameters);
    AppStorage.setOrCreate('density',Number(parameters));
    return 'call js getScreenInfo success';
  }

  listenAndroidIOS() {
    this.bridgeImpl.setMessageListener((message:bridge.Message) => {//message 应该增加类型
      let receiveAlbumRes:albumResFace[] = JSON.parse(message as string) as Array<albumResFace>;
      this.lastPageCount = receiveAlbumRes.length;
      this.isPageLoading = false;
      if(receiveAlbumRes.length === 0) {
        console.log('已经到底了');
        return false;
      }
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
      }else {
        albumRes = JSON.parse(JSON.stringify(this.xcAlbumRes.getAllData()))
      }
      receiveAlbumRes.forEach((item:albumResFace) => {
        console.log('receive message albumRes createTime: ' + item.createTime + '  uri:' + item.uri);
        albumRes.push(item.uri);
      });
      console.log('receive message albumRes length: ' + albumRes.length);

      this.handleStorageAlbum(albumRes,receiveAlbumRes);
      return "ArkUI receive message success";
    });
  }

  // 处理并存储相册资源
  async handleStorageAlbum(albumRes:Array<string>,receiveAlbumRes:albumResFace[]) {
    let videoArr:Array<string> = [];
    let photoArr:Array<string> = [];
    let screenshotArr:Array<string> = [];

    if(this.isIOS) {
      screenshotArr = AppStorage.get('screenshotArr') ? (AppStorage.get('screenshotArr') as MyDataSource).getAllData() : [];
    }

    console.log('screenshotArr:' + screenshotArr.length);
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

    if(this.currentListName === 'home') {// 首页

      let homeTabAlbumRes:MyDataSource = new MyDataSource();

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

      this.receivedAlbumRes = this.receivedAlbumRes.concat(receiveAlbumRes);
      await AppStorage.setOrCreate('receivedAlbumRes',this.receivedAlbumRes);
    }else { // 相册
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
    // this.handleChangeTab();
  }

  // 重置storage并进入不同的相册分类
  async resetEnterDiffPage(item:albumFace) {
    this.xcAlbumRes.reloadData([]);
    this.videoArr.reloadData([]);
    this.screenshotArr.reloadData([]);
    this.typeAlbumArr.reloadData([]);
    this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST,[],Constants.CACHE_IMG_LIST));
    await AppStorage.setOrCreate('typeAlbumArr',this.typeAlbumArr);
    await AppStorage.setOrCreate('xcAlbumRes',this.xcAlbumRes);

    this.bridgeImpl.callMethod('resetAlbum');
    if(item.name === 'photos') {
      this.bridgeImpl.callMethod('getAlbumPhotos');
    }
    if(item.name === 'screenshots') {
      this.bridgeImpl.callMethod('getAlbumScreenshots');
    }
    if(item.name === 'videos') {
      this.bridgeImpl.callMethod('getAlbumVideos');
    }
    this.currentListName = item.name;
    AppStorage.setOrCreate('currentListName',this.currentListName);
    router.pushUrl({
      url: Constants.URL_ALBUM_REDIRECT_PAGE
    });
  }

  //获取ios 截屏照片
  getIOSScreenshot(parameters:Record<string , bridge.Parameter> | undefined) {
    let _this:thisFace = AppStorage.get('_this') as thisFace;
    _this.isIOS = true;
    console.log('getIOSScreenshot params:');
    console.log('getIOSScreenshotisIOS params:' + this.isIOS);
    console.log('getIOSScreenshot params:' + String(parameters));
    let screenshotRes:Array<albumResFace> = JSON.parse(String(parameters));
    let tempArr: Array<string> = _this.xcAlbumRes.getAllData();
    screenshotRes.forEach((item:albumResFace) => {
      console.log('receive message screenshotArr createTime: ' + item.createTime + '  uri:' + item.uri);
      tempArr.push(item.uri);
    });

    _this.typeAlbumArr.reloadData(tempArr);
    _this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST,_this.typeAlbumArr.getAllData(),Constants.CACHE_IMG_LIST));
    _this.xcAlbumRes.reloadData(tempArr);

    AppStorage.setOrCreate('typeAlbumArr',_this.typeAlbumArr);
    AppStorage.setOrCreate('smallPhotoArr',_this.smallPhotoArr);
    AppStorage.setOrCreate('xcAlbumRes',_this.xcAlbumRes);
    AppStorage.setOrCreate('isIOS',_this.isIOS);

    return 'call js getIOSScreenshot success';
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
    }else if(this.homeTabBottomIndex === 0) {//点击图库
      if(this.homeTabIndex === 0) {//所有
        this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST,this.photoArr.getAllData(),Constants.CACHE_IMG_LIST));
      }
      if(this.homeTabIndex === 1) {//近3天
        this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST,this.photo3dArr.getAllData(),Constants.CACHE_IMG_LIST));
      }
      if(this.homeTabIndex === 2) {//近7天
        this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST,this.photo7dArr.getAllData(),Constants.CACHE_IMG_LIST));
      }
      if(this.homeTabIndex === 3) {//近1个月
        this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST,this.photo30dArr.getAllData(),Constants.CACHE_IMG_LIST));
      }

      AppStorage.setOrCreate('smallPhotoArr',this.smallPhotoArr);
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
   * 包含：CAMERA  + SCREENSHOT（图片）、SCREENSHOT（截屏录屏）、VIDEO（视频）
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
                if(this.isIOS) {
                  VideoItem({ photoArr:item.albumArr })
                }else {
                  PhotoItem({ photoArr:item.albumArr })
                }
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
