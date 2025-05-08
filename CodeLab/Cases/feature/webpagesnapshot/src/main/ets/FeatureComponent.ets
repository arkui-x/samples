import { AppRouter, DynamicsRouter } from "routermodule";
import { WebPageSnapshotComponent } from "./components/mainpage/MainPage";

@AppRouter({ name: "webpagesnapshot/WebPageSnapshot" })
@Component
export struct WebPageSnapshot {
  // 路由返回
  popRouter() {
    DynamicsRouter.popAppRouter();
  }

  build() {
    WebPageSnapshotComponent({ popRouter: this.popRouter })
  }
}