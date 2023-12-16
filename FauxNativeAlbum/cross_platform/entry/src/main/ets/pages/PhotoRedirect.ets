// 相册跳转界面
import XcAlbumPage from './XcAlbumPage';

@Entry
@Component
struct PhotoRedirect {
  @StorageLink('currentInnerPage') currentInnerPage:string = 'listPage';
  @StorageLink('lastPageCount') lastPageCount:number = 30;//最后一页的数量
  @StorageLink('isPageLoading') isPageLoading:boolean = false;//是否在请求下一页
  @StorageLink('currentListName') currentListName: string = 'home';

  aboutToAppear() {
    AppStorage.setOrCreate('currentInnerPage','listPage');
  }

  onBackPress() {
    this.lastPageCount = 30;
    this.currentListName = 'home';
    let currentInnerPage:string = AppStorage.get('currentInnerPage') as string;
    if(currentInnerPage === 'detailListPage') {
      this.currentInnerPage = 'listPage';
      return true;
    }
    return false;
  }

  build() {
    Column() {
      XcAlbumPage({
        currentPage:this.currentInnerPage,
        lastPageCount:this.lastPageCount,
        isPageLoading:this.isPageLoading
      })
    }
  }

}