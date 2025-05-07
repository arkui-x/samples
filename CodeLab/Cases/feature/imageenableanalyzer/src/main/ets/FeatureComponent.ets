import { AppRouter } from "routermodule";
import { ImageViewComponent } from "./view/ImageView";

@AppRouter({ name: "imageenableanalyzer/ImageView" })
@Component
export struct ImageView {
  build() {
    ImageViewComponent()
  }
}