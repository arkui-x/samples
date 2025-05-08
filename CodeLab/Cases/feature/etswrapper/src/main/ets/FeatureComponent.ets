import { AppRouter } from "routermodule";
import { MockNativeCallPickerViewComponent } from "./view/MockNativeCallPickerView";

@AppRouter({ name: "etswrapper/MockNativeCallPickerView" })
@Component
export struct MockNativeCallPickerView {
  build() {
    MockNativeCallPickerViewComponent()
  }
}