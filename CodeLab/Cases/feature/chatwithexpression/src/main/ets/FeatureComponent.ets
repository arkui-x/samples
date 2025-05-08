import { AppRouter } from "routermodule";
import { ChatWithExpressionComponent } from "./view/ChatWithExpression";

@AppRouter({ name: "chatwithexpression/ChatWithExpression" })
@Component
export struct ChatWithExpression {
  build() {
    ChatWithExpressionComponent()
  }
}