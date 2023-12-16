import router from '@ohos.router';
import Constants from '../common/constants/Constants';
import TopNavigation from './components/TopNavigation';

@Entry
@Component
struct VideoDetailPage {
  @State showPlayBtn:boolean = false;
  private uri:Resource = (router.getParams() as Record<string, Resource>)[`uri`];
  private controller: VideoController = new VideoController();
  @StorageLink('currentPage') currentPage: string = (router.getParams() as Record<string, string>)[`currentPage`];

  aboutToAppear() {
    console.log('this.uri'+this.uri);
  }

  build() {
    Column() {
      TopNavigation({ title:'相册',currentPage:this.currentPage })
      Stack() {
        Video({
          src:this.uri,
          controller: this.controller
        })
          .controls(false)
          .autoPlay(true)
          .height(Constants.FULL_PERCENT)
          .width(Constants.FULL_PERCENT)
          .onFinish(() => {
            this.showPlayBtn = true;
            this.controller.stop();
          })
          .onClick(() => {
            this.showPlayBtn = true;
            this.controller.stop();
          })
          if(this.showPlayBtn) {
            Image($r('app.media.play_btn'))
              .height(100)
              .width(100)
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                this.showPlayBtn = false;
                this.controller.start();
              })
          }
      }
    }
  }
}