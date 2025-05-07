import { AppRouter } from "routermodule";
import { MainViewComponent } from "./view/MainView";

@AppRouter({ name: "watermark/MainView" })
@Component
export struct MainView {
  build() {
    MainViewComponent()
  }
}