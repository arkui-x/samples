import { ScrollItem } from './ScrollItem';
import { MultiplexModel } from './MultiplexModel';
import { TitleBar } from '../../../common/TitleBar';

const MARGIN_BETWEEN: number = 15; // 间距
const SELECT_SIZE: number = 0.6; // 当前选中大小
const UNSELECT_SIZE: number = 0.5; // 未选中大小

@Entry
@Component
struct MultiplexSample {
  private scroller: Scroller = new Scroller();
  private currentX: number = 0; // 当前X轴位置
  private startScroll: boolean = false; // 开始滑动
  @StorageProp('windowWidth') windowWidth: number = 390;
  @StorageProp('windowHeight') windowHeight: number = 600;
  @State resources: Array<MultiplexModel> = new Array<MultiplexModel>();
  @State currentModel: MultiplexModel = new MultiplexModel('1', $r('app.media.img_test_1')); // 当前item
  @State onceXOffset: number = 0; // 本次滑动X轴距离
  @State @Watch('scrollIndexUpdated') scrollIndex: number = 0; // 当前滑动item下标

  aboutToAppear() {
    this.resources.push(new MultiplexModel('1', $r('app.media.img_test_1')));
    this.resources.push(new MultiplexModel('2', $r('app.media.img_test_3')));
    this.resources.push(new MultiplexModel('3', $r('app.media.img_test_2')));
    this.resources.push(new MultiplexModel('4', $r('app.media.img_test_4')));
    this.resources.push(new MultiplexModel('5', $r('app.media.img_test_5')));
    this.currentModel = this.resources[0];
  }

  scrollIndexUpdated() {
    this.currentModel = this.resources[this.scrollIndex];
    this.onceXOffset = 0;
  }

  getSize(size: number, resource: MultiplexModel) {
    let changeRatio = 0.1 * (Math.abs(this.onceXOffset) / (this.windowWidth / 2));
    let changeSize = Math.floor(size * (changeRatio > 0.1 ? 0.1 : changeRatio));
    if (this.currentModel.getId() === resource.getId()) {
      return size * SELECT_SIZE - changeSize;
    }
    return size * UNSELECT_SIZE;
  }

  getLeftMargin(resource: MultiplexModel) {
    if (this.resources.length === 0) {
      return 0;
    }
    return resource.getId() === this.resources[0].getId() ? this.windowWidth * 0.2 : -MARGIN_BETWEEN;
  }

  getRightMargin(resource: MultiplexModel) {
    if (this.resources.length === 0) {
      return 0;
    }
    return resource.getId() === this.resources[this.resources.length - 1].getId() ? this.windowWidth * 0.2 : 0;
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.Multiplex_interface') })
        .id('targetColumn')
      Scroll(this.scroller) {
        Row() {
          ForEach(this.resources, (resource: MultiplexModel) => {
            ScrollItem({
              resource: resource,
              onDelete: this.onDelete,
              resources:this.resources.length
            })
              .id(resource.getId())
              .margin({
                left: this.getLeftMargin(resource),
                right: this.getRightMargin(resource)
              })
              .width(this.getSize(this.windowWidth, resource))
              .height(this.getSize(this.windowHeight, resource))
              .zIndex(resource.getId() === this.currentModel.getId() ? 1 : 0)
              .blur(resource.getId() === this.currentModel.getId() ? 0 : 5)
          }, (item: MultiplexModel) => {
            return item.getId();
          })
        }
      }
      .id('scroll')
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off) // 滚动条常驻显示
      .edgeEffect(EdgeEffect.None)
      .onScroll((xOffset: number, yOffset: number) => {
        this.currentX += xOffset;
        this.onceXOffset += xOffset;
        let index = Math.round(this.currentX / (this.windowWidth / 2 - MARGIN_BETWEEN));
        if (index < 0) {
          index = 0;
        }
        if (index > this.resources.length - 1) {
          index = this.resources.length - 1;
        }
        this.scrollIndex = index;
      })

      .onScrollEdge((side: Edge) => {
      })
      .onScrollFrameBegin((offset: number) => {
        return { offsetRemain: offset };
      })
      .onScrollStart(() => {
        this.startScroll = true;
      })
      .onScrollStop(() => {
        this.currentX = this.scroller.currentOffset().xOffset;
        this.onceXOffset = 0;
        if (this.startScroll) {
          this.scrollCurrentIndex();
        }
        this.startScroll = false;
      })
      .height('100%')
      .margin({ top: -20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))

  }

  scrollCurrentIndex() {
    let index = 0
    for (let i = 0;i < this.resources.length; i++) {
      if (this.currentModel.getId() === this.resources[i].getId()) {
        index = i;
        break;
      }
    }
    this.scroller.scrollTo({
      xOffset: (this.windowWidth / 2) * index,
      yOffset: 0,
      animation: { duration: 100, curve: Curve.LinearOutSlowIn }
    })
  }

  onDelete = (id: string) => {
    for (let i = this.resources.length - 1;i >= 0; i--) {
      if (this.resources[i].getId() === id) {
        let isCurrent = this.resources[i].getId() === this.currentModel.getId();
        this.resources.splice(i, 1);
        if (isCurrent) {
          if (i === this.resources.length) {
            this.currentModel = this.resources[i - 1];
          } else {
            this.currentModel = this.resources[i];
          }
        }
        break;
      }
    }
    this.scrollCurrentIndex();
  }
}