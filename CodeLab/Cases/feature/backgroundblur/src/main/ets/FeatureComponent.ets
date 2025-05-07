import { AppRouter } from 'routermodule';
import { TabsSample } from './pages/TabsSample';

@AppRouter({ name: "backgroundblur/BackgroundBlurView" })
@Component
export struct BackgroundBlurView {
  build() {
    TabsSample()
  }
}