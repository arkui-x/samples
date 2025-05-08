import { AppRouter } from 'routermodule';
import { CustomDialogComponent } from './view/CustomDialog';

@AppRouter({ name: "customdialog/CustomDialog" })
@Component
export struct CustomDialog{
  build() {
    CustomDialogComponent()
  }
}