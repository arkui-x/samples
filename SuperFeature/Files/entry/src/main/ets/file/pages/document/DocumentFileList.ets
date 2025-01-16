import { FileList } from '../common/FileList';

@Entry
@Component
struct DocumentFileList {
  build() {
    Column() {
      FileList(
        {
          title: $r('app.string.document'),
        })
    }
  }
}
