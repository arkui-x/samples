
import window from '@ohos.window';

@Entry
@Component
struct WindowContent1 {
    private windowStage? : window.WindowStage = AppStorage.get("windowStage");

    build() {
        Row() {
            Column() {
                Text("sub window Color space 相关测试").margin({ top: 20 })
                Button("subwindow.getWindowColorSpace")
                    .onClick(() => {
                      if (this.windowStage == undefined) {
                        return
                      }
                            this.windowStage.getSubWindow((err, data)=>{
                            if (err.code) {
                                console.info('subwindow.on error');
                                return;
                            }
                            let colorSpace = data[0].getWindowColorSpace()
                            console.info(' subwindow.get colorSpace: ' + colorSpace);
                        })
                        console.info('subwindow. getcolorSpace ');
                    }).margin({ top: 5 })
                Button("subwindow.setWindowColorSpace DEFAULT")
                    .onClick(() => {
                        try {
                          if (this.windowStage == undefined) {
                            return
                          }
                                this.windowStage.getSubWindow((err, data)=>{
                                if (err.code) {
                                    console.info('subwindow.on error');
                                    return;
                                }
                                data[0].setWindowColorSpace(window.ColorSpace.DEFAULT, (data)=>{
                                    console.info(' subwindow set colorSpace DEFAULT success');
                                })

                            })
                        } catch (exception) {
                            console.info("window.setWindowColorSpace: failed")
                        }
                    })
                    .margin({ top: 5 })
                Button("subwindow.setWindowColorSpace WIDE_GAMUT")
                    .onClick(() => {
                        try {
                          if (this.windowStage == undefined) {
                            return
                          }
                                this.windowStage.getSubWindow((err, data)=>{
                                if (err.code) {
                                    console.info('subwindow.on error');
                                    return;
                                }
                                data[0].setWindowColorSpace(window.ColorSpace.WIDE_GAMUT, (data)=>{
                                    console.info(' subwindow set colorSpace WIDE_GAMUT success');
                                })

                            })
                        } catch (exception) {
                            console.info("window.setWindowColorSpace: failed")
                        }
                    })
                    .margin({ top: 5 })
            }
            .width('100%')
        }.backgroundColor(0xFF0000)
        .height('100%')
    }
}