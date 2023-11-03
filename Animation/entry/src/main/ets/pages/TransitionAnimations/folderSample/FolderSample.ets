import { TitleBar } from '../../../common/TitleBar';
import Folder from './Folder';

@Entry
@Component
struct FolderSample {
  @StorageProp('windowHeight') windowHeight: number = 720;
  @State isOpen: boolean = false;
  @State widthSize: number = 80;
  @State heightSize: number = 80;
  @State translateY: number = 0;

  click() {
    if (!this.isOpen) {
      this.widthSize = 280;
      this.heightSize = 280;
      this.translateY = this.windowHeight * 0.1;
    } else {
      this.widthSize = 80;
      this.heightSize = 80;
      this.translateY = 0;
    }
    animateTo({ duration: 500 }, () => {
      this.isOpen = !this.isOpen;
    });
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.Folder_expansion') })
      Column() {
        Folder({ isOpen: $isOpen })
          .id('folderComponent')
          .onClick(() => {
            this.click();
          })
          .width(this.widthSize)
          .height(this.heightSize)
          .translate({ y: this.translateY })
          .animation({
            duration: 500,
            curve: Curve.Linear,
            playMode: PlayMode.Normal
          })
      }
      .padding(20)
      .width('100%')
      .height('100%')
      .backgroundImageSize({
        height: '100%'
      })
      .backgroundImage($r('app.media.img_test_2'))
      .backdropBlur(this.isOpen ? 10 : 0)
      .onClick(() => {
        if (this.isOpen) {
          this.click();
        }
      })
    }
    .width('100%')
    .height('100%')
  }
}