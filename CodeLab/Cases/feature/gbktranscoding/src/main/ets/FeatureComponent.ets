import { AppRouter } from "routermodule";
import { FriendsBookComponent } from "./pages/FriendsBook";

@AppRouter({ name: "gbktranscoding/FriendsBook" })
@Component
export struct FriendsBook {
  build() {
    FriendsBookComponent()
  }
}