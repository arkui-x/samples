import { AppRouter } from "routermodule";
import { VideoCacheViewComponent } from "./view/VideoCacheView";

@AppRouter({ name: "videocache/VideoCacheView" })
@Component
export struct VideoCacheView {
  build() {
    VideoCacheViewComponent()
  }
}