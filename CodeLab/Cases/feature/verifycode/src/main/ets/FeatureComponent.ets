import { AppRouter, DynamicsRouter } from "routermodule";
import { VerifyCodeViewComponent } from "./view/VerifyCodeView";
import { emitter } from "@kit.BasicServicesKit";

@AppRouter({ name: "verifycode/VerifyCodeView" })
@Component
export struct VerifyCodeView {
  // 路由返回
  popRouter() {
    DynamicsRouter.popAppRouter();
  }
  build() {
    VerifyCodeViewComponent({popRouter: this.popRouter});
  }
}