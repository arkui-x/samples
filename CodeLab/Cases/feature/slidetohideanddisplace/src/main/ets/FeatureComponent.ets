import { AppRouter } from "routermodule";
import { SlideToHideAndDisplaceComponent } from "./view/SlideToHideAndDisplace";

@AppRouter({ name: "slidetohideanddisplace/SlideToHideAndDisplace" })
@Component
export struct SlideToHideAndDisplace {
  build() {
    SlideToHideAndDisplaceComponent()
  }
}