import { AppRouter } from "routermodule";
import { ImageCompressionComponent } from "./view/ImageCompression";

@AppRouter({ name: "imagecompression/ImageCompression" })
@Component
export struct ImageCompression {
  build() {
    ImageCompressionComponent()
  }
}