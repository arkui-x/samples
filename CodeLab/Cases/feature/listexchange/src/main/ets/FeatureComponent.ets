import { AppRouter } from "routermodule";
import { ListExchangeViewComponent } from "./view/ListExchangeView";

@AppRouter({ name: "listexchange/ListExchangeView" })
@Component
export struct ListExchangeView {
  build() {
    ListExchangeViewComponent()
  }
}