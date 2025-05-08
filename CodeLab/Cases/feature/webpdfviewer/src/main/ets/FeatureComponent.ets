import { AppRouter } from "routermodule";
import { WebPDFViewerComponent } from "./view/WebPDFViewer";

@AppRouter({ name: "webpdfviewer/WebPDFViewer" })
@Component
export struct WebPDFViewer {
  build() {
    WebPDFViewerComponent()
  }
}