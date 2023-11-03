import router from '@ohos.router'

interface routerFace {
  url:string,
  params:object
}

let routerObj:router.RouterOptions = {
  url:'pages/loginPage',
  params:{}
};

PersistentStorage.persistProp('routerObj',routerObj);
PersistentStorage.persistProp('homeTabBottomIndex',0);
PersistentStorage.persistProp('homeTabTopIndex',0);


@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  @StorageLink('routerObj') routerObj: router.RouterOptions = {
    url:'pages/loginPage'
  };

  aboutToAppear() {
    console.log('routerObj:' + JSON.stringify(this.routerObj))
    router.pushUrl(this.routerObj)
  }

  build() {

  }
}