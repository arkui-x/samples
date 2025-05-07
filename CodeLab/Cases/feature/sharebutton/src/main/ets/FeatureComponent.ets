import { AppRouter, DynamicsRouter } from "routermodule";
import { openShare } from "./components/ShareButton";

const AGC_APP_LINK = "https://appgallery.huawei.com/app/detail?id=com.north.cases"


@AppRouter({ name: "sharebutton/MockSharePage" })
@Component
export struct MockSharePage {
  aboutToAppear(): void {
    openShare(getContext(), AGC_APP_LINK, () => {
      // 关闭弹窗后回调，退出案例
      DynamicsRouter.popAppRouter();
    });
  }

  build() {
  }
}