import { AppRouter } from "routermodule";
import { ImageCommentViewComponent } from "./components/view/ImageCommentView";

@AppRouter({ name: "imagecomment/ImageCommentView" })
@Component
export struct ImageCommentView {
  build() {
    ImageCommentViewComponent()
  }
}