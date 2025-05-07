import { AppRouter } from "routermodule";
import { CardSwiperAnimationComponent } from "./view/CardSwiper";

@AppRouter({ name: "cardswiperanimation/CardSwiperAnimation" })
@Component
export struct CardSwiperAnimation{
  build() {
    CardSwiperAnimationComponent()
  }
}