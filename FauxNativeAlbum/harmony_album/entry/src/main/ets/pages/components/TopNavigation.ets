import Constants from '../../common/constants/Constants';
import router from '@ohos.router';

@Component
export default struct TopNavigation {
  @Prop title: string;
  @Link currentPage: string;
  @StorageLink('lastPageCount') lastPageCount: number = 30; //The number of last pages
  @StorageLink('homeTabBottomIndex') homeTabBottomIndex: number = 0;
  @StorageLink('currentListName') currentListName: string = 'home';

  handlePressBackBtn() {
    console.log('this.currentPage:' + this.currentPage);
    if (this.homeTabBottomIndex === 1 && this.currentPage === 'listPage') {
      this.lastPageCount = 30;
      this.currentListName = 'home';
    }
    if (this.currentPage === 'detailListPage') {
      this.currentPage = 'listPage';
    } else if (this.currentPage === 'detailPage' || this.currentPage === 'videoDetailPage') {
      this.currentPage = 'detailListPage';
      router.back();
    } else if (this.currentPage === 'listPage') {
      this.homeTabBottomIndex === 1 ? router.back() : this.currentPage = 'listPage';
    }
  }

  build() {
    Column() {
      Stack() {
        Image($r('app.media.back'))
          .width(30)
          .position({ x: 10, y: 0 })
        Text(this.title || Constants.PAGE_TITLE)
          .fontSize(Constants.PAGE_TITLE_SIZE)
          .width(Constants.FULL_PERCENT)
          .textAlign(TextAlign.Center)
      }
      .backgroundColor('#f7f7f7')
      .padding(7)
      .onClick(() => {
        this.handlePressBackBtn();
      })
    }
  }
}