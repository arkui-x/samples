import router from '@ohos.router';

// 功能模块数据
interface FeatureItem {
  id: string;
  name: string;
  desc: string;
  icon: string;
  color: string;
  bgColor: string;
  route: string;
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  private features: FeatureItem[] = [
    {
      id: 'Picker',
      name: 'Picker',
      desc: '日期时间选择',
      icon: '📅',
      color: '#007AFF',
      bgColor: '#E6F2FF',
      route: 'pages/Picker'
    },
    {
      id: 'Text',
      name: 'Text',
      desc: '文本输入组件',
      icon: '📝',
      color: '#5856D6',
      bgColor: '#F0EFFF',
      route: 'pages/Text'
    },
    {
      id: 'Web',
      name: 'Web',
      desc: '网页浏览',
      icon: '🌐',
      color: '#34C759',
      bgColor: '#E8F5E9',
      route: 'pages/Web'
    },
    {
      id: 'Slider',
      name: 'Slider',
      desc: '滑动条组件',
      icon: '🎚️',
      color: '#FF9500',
      bgColor: '#FFF5E6',
      route: 'pages/Slider'
    },
    {
      id: 'AlphabetIndexer',
      name: 'AlphabetIndexer',
      desc: '字母索引',
      icon: '🔤',
      color: '#FF2D55',
      bgColor: '#FFE8ED',
      route: 'pages/AlphabetIndexer'
    },
    {
      id: 'Drag',
      name: 'Drag',
      desc: '拖拽交互',
      icon: '✋',
      color: '#5AC8FA',
      bgColor: '#E8F8FF',
      route: 'pages/Drag'
    },
    {
      id: 'uipicker',
      name: 'UI Picker',
      desc: 'UI选择器',
      icon: '🎨',
      color: '#AF52DE',
      bgColor: '#F5E8FF',
      route: 'pages/uipicker'
    },
    {
      id: 'richeditor',
      name: 'RichEditor:bindSelectionMenu',
      desc: '自定义选择菜单',
      icon: '📄',
      color: '#007AFF',
      bgColor: '#E6F2FF',
      route: 'pages/RicheditorContextMenu'
    },
    {
      id: 'TextBindContextMenu',
      name: 'Text:bindContextMenu',
      desc: 'Text组件绑定通用属性弹窗菜单',
      icon: '📋',
      color: '#34C759',
      bgColor: '#E8F5E9',
      route: 'pages/CommonBindContextMenu'
    },
  ];

  @Builder
  FeatureCard(feature: FeatureItem, index: number) {
    Column({ space: 12 }) {
      // 图标和编号
      Row() {
        Text(feature.icon)
          .fontSize(32)
        Blank()
        Text((index + 1).toString().padStart(2, '0'))
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor(feature.color)
          .opacity(0.6)
      }
      .width('100%')

      // 名称
      Text(feature.name)
        .fontSize(18)
        .fontWeight(FontWeight.Lighter)
        .fontColor('#1a1a1a')

      // 描述
      Text(feature.desc)
        .fontSize(13)
        .fontColor('#999999')
    }
    .width('100%')
    .aspectRatio(1)
    .padding(16)
    .backgroundColor('#ffffff')
    .borderRadius(16)
    .shadow({
      radius: 8,
      color: '#00000008',
      offsetX: 0,
      offsetY: 2
    })
    .onClick(() => {
      router.pushUrl({ url: feature.route });
    })
  }

  build() {
    Column({ space: 0 }) {
      // 顶部标题栏
      Column({ space: 8 }) {
        Text('组件示例')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1a1a1a')
          .letterSpacing(0.5)
        Text('Arkui-x 触控反馈组件演示')
          .fontSize(14)
          .fontColor('#999999')
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({
        left: 20,
        right: 20,
        top: 48,
        bottom: 20
      })
      .backgroundColor('#ffffff')

      // 功能网格
      Scroll() {
        Grid() {
          ForEach(this.features, (feature: FeatureItem, index: number) => {
            GridItem() {
              this.FeatureCard(feature, index)
            }
          }, (feature: FeatureItem) => feature.id)
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(12)
        .rowsGap(12)
        .padding(16)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .backgroundColor('#f5f5f7')

      // 底部信息
      Text(`共 ${this.features.length} 个组件示例`)
        .fontSize(12)
        .fontColor('#999999')
        .padding(16)
        .backgroundColor('#f5f5f7')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f7')
  }
}
