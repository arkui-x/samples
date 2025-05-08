import { AppRouter } from "routermodule";
import { FitForDarkModeComponent } from "./view/FitForDarkMode";

@AppRouter({ name: "fitfordarkmode/FitForDarkMode" })
@Preview
@Component
export struct FitForDarkMode {
  build() {
    FitForDarkModeComponent()
  }
}