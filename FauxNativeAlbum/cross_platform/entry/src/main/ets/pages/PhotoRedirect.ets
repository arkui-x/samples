// 相册跳转界面
import XcAlbumPage from './XcAlbumPage';

@Entry
@Component
struct PhotoRedirect {
  @StorageLink('currentInnerPage') currentInnerPage: string = 'listPage';
  @StorageLink('currentPage') currentPage: string = 'listPage';
  @StorageLink('lastPageCount') lastPageCount: number = 30; //The number of last pages
  @StorageLink('isPageLoading') isPageLoading: boolean = false; //Whether to request the next page
  @StorageLink('currentListName') currentListName: string = 'home';

  aboutToAppear() {
    AppStorage.setOrCreate('currentInnerPage', 'listPage');
  }

  onBackPress() {
    this.lastPageCount = 30;
    this.currentListName = 'home';
    let currentInnerPage: string = AppStorage.get('currentInnerPage') as string;
    if (currentInnerPage === 'detailListPage') {
      this.currentInnerPage = 'listPage';
      return true;
    }
    return false;
  }

  build() {
    Column() {
      XcAlbumPage({
        currentPage: this.currentPage,
        lastPageCount: this.lastPageCount,
        isPageLoading: this.isPageLoading
      })
    }
  }
}