import { AppRouter } from "routermodule";
import { SecondFloorLoadAnimationComponent } from "./view/SecondFloorLoadAnimation";

@AppRouter({ name: "secondfloorloadanimation/SecondFloorLoadAnimation" })
@Component
export struct SecondFloorLoadAnimation {
  build() {
    SecondFloorLoadAnimationComponent()
  }
}