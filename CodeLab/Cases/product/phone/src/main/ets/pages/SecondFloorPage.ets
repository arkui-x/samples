import { SecondFloorLoadAnimationComponent } from "../../../../../../feature/secondfloorloadanimation/src/main/ets/view/SecondFloorLoadAnimation";
@Entry
@Component
struct SecondFloorPage {
  build() {
    Column() {
      SecondFloorLoadAnimationComponent()
    }
    .width('100%')
    .height('100%')
  }
}