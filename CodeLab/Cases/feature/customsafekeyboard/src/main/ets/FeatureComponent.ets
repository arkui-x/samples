import { AppRouter } from "routermodule";
import { CustomSafeKeyboardViewComponent } from "./view/CustomSafeKeyboardView";

@AppRouter({ name: "customsafekeyboard/CustomSafeKeyboardView" })
@Component
export struct CustomSafeKeyboardView {
  build() {
    CustomSafeKeyboardViewComponent()
  }
}