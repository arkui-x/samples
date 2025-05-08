import { AppRouter } from "routermodule";
import { AddressExchangeViewComponent } from "./view/AddressExchangeView";

@AppRouter({ name: "addressexchange/AddressExchangeView" })
@Component
export struct AddressExchangeView {
  build() {
    AddressExchangeViewComponent()
  }
}