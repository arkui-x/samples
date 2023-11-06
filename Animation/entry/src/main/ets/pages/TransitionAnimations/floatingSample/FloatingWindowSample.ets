import curves from '@ohos.curves';
import display from '@ohos.display';
import { TitleBar } from '../../../common/TitleBar'
import FloatingWindowComponent from './FloatingWindowComponent';
import Logger from '../../../util/Logger';

const TAG = '[FloatingWindowPage]';

@Entry
@Component
struct FloatingWindowSample {
  private diameter: number = 120; // 触摸点相对偏移量
  @State positionX: number = 50; // 组件位置X
  @State positionY: number = 500; // 组件位置Y
  @State displayHalfWidth: number = 0; // 屏幕一半的宽
  @State displayHalfHeight: number = 0; // 屏幕一半的高
  @State moveStartX: number = 0; // X方向起始点
  @State moveStartY: number = 0; // Y方向起始点
  @State moveEndX: number = 0; // X方向终点
  @State moveEndY: number = 0; // Y方向终点

  aboutToAppear() {
    let displayModel = display.getDefaultDisplaySync()
    try {
      // 拿到屏幕宽高的一半，作为判断基准值
      this.displayHalfWidth = displayModel.width / 2;
      this.displayHalfHeight = displayModel.height / 2;
      // 将拿到的px转为vp
      Logger.info(TAG, `aboutToAppear getAllDisplays data 1 width:${this.displayHalfWidth}, height:${this.displayHalfHeight}`);
      this.displayHalfWidth = px2vp(this.displayHalfWidth);
      this.displayHalfHeight = px2vp(this.displayHalfHeight);
      Logger.info(TAG, `aboutToAppear getAllDisplays data 2 width:${this.displayHalfWidth}, height:${this.displayHalfHeight}`);
    } catch (error) {
      Logger.info(TAG, `aboutToAppear getAllDisplays data 1 error:${JSON.stringify(error)}`)
    }
  }

  build() {
    Row() {
      Column() {
        TitleBar({ title: $r('app.string.Floating_window') })
          .id('target')
        Checkbox().width(0.5).height(0.5)
        TextInput({ placeholder: $r('app.string.avoiding_input_method_testing') })
          .width('95%').height(50)
          .id('test_inputTab')
        Row() {
          Row() {
            FloatingWindowComponent()
          }
          .id('floatingWindowComponent')
          .width(80)
          .height(80)
          .position({ x: this.positionX, y: this.positionY })
          .onTouch((event: TouchEvent) => {
            if (event.type === TouchType.Down) {
              this.moveStartX = event.touches[0].windowX; // 按下时获取X坐标初始值
              this.moveStartY = event.touches[0].windowY; // 按下时获取Y坐标初始值
            }
            if (event.type === TouchType.Move) {
              this.moveEndX = event.touches[0].windowX; // X方向移动的当前位置
              this.moveEndY = event.touches[0].windowY; // Y方向移动的当前位置
              this.moveStartX = this.moveEndX;
              this.moveStartY = this.moveEndY;
              // 跟手过程，使用responsiveSpringMotion曲线
              animateTo({ curve: curves.responsiveSpringMotion() }, () => {
                // 减去半径，以使球的中心运动到手指位置
                this.positionX = event.touches[0].windowX - this.diameter / 2;
                this.positionY = event.touches[0].windowY - this.diameter / 2 - 120;
                Logger.info(TAG, `move end, animateTo x:${this.positionX}, y:${this.positionY}`);
              })
            }
            if (event.type === TouchType.Up) {
              // 离手时，使用springMotion曲线，且将移动时速度赋值给离手时速度
              animateTo({ curve: curves.springMotion(), tempo: 0.5 }, () => {
                if (this.positionX >= this.displayHalfWidth) {
                  // 如果划到右边，则定位至屏幕右边减去自身宽度80，再减去10留出间隙
                  this.positionX = this.displayHalfWidth * 2 - 90;
                } else {
                  this.positionX = 10;
                }
                if (this.positionY >= this.displayHalfHeight * 2 - 300) {
                  this.positionY = this.displayHalfHeight * 2 - 300;
                } else if (this.positionY <= 0) {
                  this.positionY = 10;
                }
                Logger.info(TAG, `touchUp, animateTo x:${this.displayHalfWidth}, y:100`);
              })
            }
          })
        }
        .width('100%')
        .height('92%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.background_shallow_grey'))
    }
    .width('100%')
    .height('100%')
  }
}