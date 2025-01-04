import photoAccessHelper from '@ohos.file.photoAccessHelper';
import { BusinessError } from '@ohos.base';
import ArrayList from '@ohos.util.ArrayList';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import common from '@ohos.app.ability.common';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import MyDataSource from '../bean/MyDataSource';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State mimeTypes: string = 'PhotoViewMIMETypes:IMAGE_TYPE'

  @State dataMessage: string = "返回数据"

 // @State messageImage: string[] = [];
  @State messageImage: MyDataSource = new MyDataSource();

  @State vedioUrl: string[] = [];

  controller: VideoController = new VideoController()

  private scroller: Scroller = new Scroller();
  @StorageLink('selectedIndex') selectedIndex: number = 0;

  handleClick() {
    router.pushUrl({
      url: 'pages/DetailPage',
    })
  }

  async aboutToAppear() {
    try {
      let context: Context = getContext(this) as common.UIAbilityContext;
      let atManager = abilityAccessCtrl.createAtManager();
      atManager.requestPermissionsFromUser(context, ["ohos.permission.READ_IMAGEVIDEO"]).then((data) => {
      }).catch((err: BusinessError) => {
        console.info("requestPermissionsFromUser read data:" + JSON.stringify(err));
      })
    } catch(err) {
      console.log(`catch err->${JSON.stringify(err)}`);
    }
  }

  build() {
      Column() {
        Blank(30)
        Row() {
          Button('挑选图片', { type: ButtonType.Normal, stateEffect: true })
            .width(95)
            .fontSize(9)
            .onClick(()=>{
              this.selectOption('PhotoViewMIMETypes:IMAGE_TYPE');
              // this.fetchResultTestFun();
            })
          Blank(10)
          Button('挑选视频', { type: ButtonType.Normal, stateEffect: true })
            .width(95)
            .fontSize(9)
            .onClick(()=>{
              this.selectOption('PhotoViewMIMETypes:VIDEO_TYPE');
            })
          Blank(10)
          Button('挑选所有媒体资源', { type: ButtonType.Normal, stateEffect: true })
            .width(130)
            .fontSize(9)
            .onClick(()=>{
              this.selectOption('PhotoViewMIMETypes:IMAGE_VIDEO_TYPE');
            })
          Blank(10)
        }
        Blank(30)

        Grid(this.scroller) {
          LazyForEach(this.messageImage, (img: string, index?: number) => {
            GridItem() {
              if (this.checkIsVideo(String(img))) {
                Stack() {
                  Video({ src: img })
                    .controls(true)
                    .autoPlay(true)
                    .height('100%')
                    .width('100%')
                    .objectFit(ImageFit.Contain)
                    .onClick(() => {
                      this.selectedIndex = index as number;
                      this.handleClick();
                    })
                }
              } else {
                Image(img)
                  .height('100%')
                  .width('100%')
                  .sourceSize({
                    width: 100,
                    height: 100
                  })
                  .objectFit(ImageFit.Cover)
                  .onClick(() => {
                    this.selectedIndex = index as number;
                    this.handleClick();
                  })
              }
            }
            .width('100%')
            .aspectRatio(1)
          }, (item: Resource) => JSON.stringify(item))
        }
        .cachedCount(15)
        .columnsTemplate('1fr 1fr 1fr')
        .rowsGap(2)
        .columnsGap(2)
        .layoutWeight(1)
        .onScrollIndex((first, last) => {
        })
        Blank(10)
      }
      .width('100%')
  }

  checkIsVideo(message: string): boolean {
    if (message.includes('mp4') || message.includes('mov') || message.includes('MP4') || message.includes('MOV')) {
      return true;
    } else {
      return false;
    }
  }

  checkIsImage(message: string): boolean {
    if (message.includes('jpeg') || message.includes('png') || message.includes('jpg')) {
      return true;
    } else {
      return false;
    }
  }


  selectOption(type: string): void {
    console.info("yanTestNow select in");
    let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    if (type == 'PhotoViewMIMETypes:IMAGE_TYPE') {
      PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    } else if (type == 'PhotoViewMIMETypes:VIDEO_TYPE') {
      PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE;
    } else if (type == 'PhotoViewMIMETypes:IMAGE_VIDEO_TYPE') {
      PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    } else {
      PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    }
    let photoPicker = new photoAccessHelper.PhotoViewPicker();
    console.info("yanTestNow select in 1");
    photoPicker.select(PhotoSelectOptions).then((PhotoSelectResult: photoAccessHelper.PhotoSelectResult) => {
      this.dataMessage = JSON.stringify(PhotoSelectResult);
      console.info('yanTestNow PhotoViewPicker select successfully, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult));
      this.setImageAndVideoData(PhotoSelectResult);
    }).catch((err: BusinessError) => {
      console.error(`yanTestNow PhotoViewPicker select failed with err: ${err.code}, ${err.message}`);
    });
    console.info("yanTestNow select end");
  }

  setImageAndVideoData(PhotoSelectResult: photoAccessHelper.PhotoSelectResult) {
    this.messageImage.clearData();
    this.controller.stop();
    PhotoSelectResult.photoUris.forEach((urlstring: string) => {
      this.messageImage.pushData(urlstring);
    });
    AppStorage.setOrCreate('photoArr', this.messageImage);
  }
}