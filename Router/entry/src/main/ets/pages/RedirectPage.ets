import router from '@ohos.router'

let routerObj:router.RouterOptions = {
  url:'pages/loginPage',
  params:{}
};

/**
 * 持久化存储
 * routerObj 路由相关的信息
 * homeTabBottomIndex 首页底部切换tab index,默认为0
 * homeTabTopIndex 首页第一个tab中，顶部tab切换index,默认为0
 */
PersistentStorage.persistProp('routerObj',routerObj);
PersistentStorage.persistProp('homeTabBottomIndex',0);
PersistentStorage.persistProp('homeTabTopIndex',0);

@Entry
@Component
struct Index {
  @StorageLink('routerObj') routerObj: router.RouterOptions = {
    url:'pages/loginPage'
  };

  aboutToAppear() {
    console.log('routerObj:' + JSON.stringify(this.routerObj));
    router.pushUrl(this.routerObj);
  }

  build() {

  }
}