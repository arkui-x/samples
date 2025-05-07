import { AppRouter } from "routermodule";
import { StyledTextMainPageComponent } from "./pages/StyledText";

@AppRouter({ name: "styledtext/StyledTextMainPage" })
@Component
export struct StyledTextMainPage {
  build() {
    StyledTextMainPageComponent()
  }
}