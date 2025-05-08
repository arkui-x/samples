import { AppRouter } from "routermodule";
import { HalfModalWindowComponent } from "./view/HalfModalWindow";

@AppRouter({ name: "multimodaltransion/HalfModalWindow" })
@Component
export struct HalfModalWindow {
  build() {
    HalfModalWindowComponent()
  }
}