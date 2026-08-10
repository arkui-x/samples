import { router } from '@kit.ArkUI';

// ========== 导航数据 ==========
interface NavItem {
  title: string;
  route: string;
  icon: string;
  description: string;
}

// ========== 导航卡片组件 ==========
@Component
struct NavCard {
  @Prop item: NavItem = { title: '', route: '', icon: '', description: '' };

  build() {
    Column() {
      Text(this.item.icon)
        .fontSize(36)
        .margin({ bottom: 10 })

      Text(this.item.title)
        .fontSize(17)
        .fontWeight(FontWeight.Medium)

      Text(this.item.description)
        .fontSize(12)
        .fontColor('#8c8c8c')
        .margin({ top: 6 })

      Text('点击进入 >')
        .fontSize(12)
        .fontColor('#1890ff')
        .margin({ top: 14 })
    }
    .width('100%')
    .padding(24)
    .borderRadius(16)
    .backgroundColor('#ffffff')
    .shadow({
      radius: 10,
      color: '#0000001a',
      offsetX: 0,
      offsetY: 4
    })
    .onClick(() => {
      router.pushUrl({ url: this.item.route });
    })
  }
}

// ========== 主页面 ==========
@Entry
@Component
struct SecondPage {
  private navItems: NavItem[] = [
    {
      title: 'Web多窗口 页面',
      route: 'pages/Index',
      icon: '',
      description: 'Web 多窗口接口测试面板'
    },
    {
      title: 'onRenderExited 页面',
      route: 'pages/onRenderExited',
      icon: '',
      description: 'WebView 渲染进程退出测试'
    },
    {
      title: 'SetWebController(Null) 页面',
      route: 'pages/SetWebControllerNull',
      icon: '',
      description: 'setWebController(null) 测试'
    },
    {
      title: 'OnWindowNew(Null/Undefined) 页面',
      route: 'pages/OnWindowNewNullUndefined',
      icon: '',
      description: 'onWindowNew回调传null/undefined测试'
    },
    {
      title: 'AllowWindowOpenMethod 页面',
      route: 'pages/AllowWindowOpenMethod',
      icon: '',
      description: 'allowWindowOpenMethod接口测试(true/false/null/undefined)'
    },
    {
      title: 'MultiWindowAccess 页面',
      route: 'pages/MultiWindowAccess',
      icon: '',
      description: 'multiWindowAccess异常值测试(null/undefined)'
    },
    {
      title: 'OnWindowExit 页面',
      route: 'pages/OnWindowExit',
      icon: '',
      description: 'onWindowExit回调测试(子窗口关闭触发)'
    }
  ];

  build() {
    Column() {
      // 标题区
      Text('Web 接口测试中心')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 60, bottom: 36 })

      Text('选择要测试的页面')
        .fontSize(13)
        .fontColor('#888888')

      // 卡片列表
      List() {
        ForEach(this.navItems, (item: NavItem) => {
          ListItem() {
            NavCard({ item: item })
          }.padding({ left: 24, right: 24, bottom: 14 })
        }, (item: NavItem) => item.route)
      }
      .width('100%')
      .layoutWeight(1)

      // 底部
      Text('共 ' + this.navItems.length + ' 个测试页面')
        .fontSize(11)
        .fontColor('#bfbfbf')
        .margin({ bottom: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f7fa')
  }
}
