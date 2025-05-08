import { AppRouter } from "routermodule";
import { MainPageComponent } from "./components/mainpage/MainPage";

@AppRouter({ name: "effectKit/MainPage" })
@Component
export struct MainPage {
  build() {
    MainPageComponent()
  }
}