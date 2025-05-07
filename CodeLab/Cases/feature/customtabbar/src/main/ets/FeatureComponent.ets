import { AppRouter } from 'routermodule';
import { TabViewComponent } from './view/TabView';

@AppRouter({ name: "customtabbar/TabView" })
@Component
export struct TabView {
  build() {
    TabViewComponent()
  }
}