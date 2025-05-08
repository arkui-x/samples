import { AppRouter } from "routermodule";
import { PullToRefreshNewsComponent } from "./pages/PullToRefreshNews";

@AppRouter({ name: "pulltorefreshnews/PullToRefreshNews" })
@Component
export struct PullToRefreshNews {
  build() {
    PullToRefreshNewsComponent()
  }
}