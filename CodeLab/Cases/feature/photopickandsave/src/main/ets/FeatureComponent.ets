import { AppRouter } from 'routermodule';
import { PictureManagerComponent } from './components/PictureManager';

@AppRouter({ name: "photopickandsave/PictureManager" })
@Component
export struct PictureManager {
  build() {
    PictureManagerComponent()
  }
}