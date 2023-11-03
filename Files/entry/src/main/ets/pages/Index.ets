import FileManagerHome from '../file/pages/FileManagerHome'

@Entry
@Component
struct Index {
  build() {
    Row() {
      FileManagerHome()
    }
  }
}
