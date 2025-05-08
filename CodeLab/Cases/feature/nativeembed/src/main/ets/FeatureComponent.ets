import { AppRouter } from "routermodule";
import { WebViewDemoComponent } from "./view/NativeEmbedView";

@AppRouter({ name: "nativeembed/WebViewDemo" })
@Component
export struct WebViewDemo {
  build() {
    WebViewDemoComponent()
  }
}