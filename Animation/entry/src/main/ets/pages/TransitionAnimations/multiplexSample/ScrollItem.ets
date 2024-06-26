import { MultiplexModel } from './MultiplexModel';

@Component
export struct ScrollItem {
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Vertical, fingers: 1 });
  @Prop resource: MultiplexModel;
  private onDelete: (id: string) => void = () => {
  };
  @Prop resources: number = 5
  @StorageProp('windowHeight') windowHeight: number = 720;
  @State offsetX: number = 0; // X轴滑动距离
  @State offsetY: number = 0; // Y轴滑动距离
  @State scaleX: number = 1; // 缩放比例
  @State angle: number = 0; // 旋转角度
  @State translateY: number = 0; // Y轴移动距离
  @State sx: number = 1; // 滑动系数

  build() {
    Column() {
      Stack() {
        Image(this.resource.getImg())
          .width('100%')
          .height('100%')
          .borderRadius(20)
          .shadow({
            radius: 20,
            color: $r('app.color.btn_border_color')
          })
      }
      .width('100%')
      .height('100%')
      .scale({
        x: this.scaleX,
        y: this.scaleX,
        z: this.scaleX,
      })
      .rotate({
        x: 1,
        y: 0,
        z: 0,
        centerX: '50%',
        centerY: '100%',
        angle: this.angle
      })
      .translate({
        x: 0,
        y: this.translateY,
        z: this.translateY
      })
      .opacity(this.sx)
    }
    .borderRadius(20)
    .justifyContent(FlexAlign.Center)
    .gesture(
      PanGesture(this.panOption)
        .onActionStart(() => {
          console.info('Pan start');
        })
      .onActionUpdate((event: GestureEvent) => {
        if (this.translateY >= 115) this.translateY = 110
        if (this.resources > 1 && this.translateY <= 115) {
            let sxNumber: number = 0;
            if (event.offsetY - this.offsetY <= 0) {
              sxNumber = (this.sx - Math.abs(event.offsetY - this.offsetY) / this.windowHeight);
            } else if (event.offsetY - this.offsetY > 0) {
              sxNumber = (this.sx + Math.abs(event.offsetY - this.offsetY) / this.windowHeight);
            }
            this.move(sxNumber);
            this.offsetX = event.offsetX;
            this.offsetY = event.offsetY;
          }
        })
        .onActionEnd(() => {
          if (this.resources > 1) {
            this.offsetX = 0;
            this.offsetY = 0;
            console.info('Pan end');
            if (this.scaleX >= 0.15 && this.scaleX <= 1) {
              this.move(1)
              this.restore();
            } else if (this.scaleX < 0.15) {
              this.delete();
            }
          }
        })
    )
  }

  move(sx: number) {
    this.sx = sx > 1 ? 1 : sx < 0 ? 0 : sx;
    this.scaleX = Math.pow(sx, 7) > 1 ? 1 : sx < 0 ? 0 : Math.pow(sx, 7);
    let an = Math.pow((1 - sx) * 30, 2);
    this.angle = an > 90 ? 90 : an;
    let y = Math.log((2 - sx)) * -(this.windowHeight * 2);
    this.translateY = y > 0 ? 118 : (y + 120);
    console.info('Pan sx:' + this.sx);
    console.info('Pan scaleX:' + this.scaleX);
    console.info('Pan translateY:' + this.translateY);
    console.info('Pan angle:' + this.angle);
  }

  /**
   * 还原
   */
  restore() {
    let that = this;
    setTimeout(() => {
      that.sx = 1
      that.scaleX = 1
      that.angle = 0
      that.translateY = 0
    }, 50)
  }

  /**
   * 删除
   */
  delete() {
    let that = this;
    let intervalID: number = setInterval(() => {
      if (intervalID > 0) {
        that.move(that.sx -= 0.01);
        if (that.sx < 0.2) {
          clearInterval(intervalID);
          intervalID = 0
          that.onDelete(that.resource.getId());
        }
      }
    }, 10)
  }
}