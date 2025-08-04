import { BusinessError, request } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { expect } from '@ohos/hypium'
import router from '@ohos.router'

@Entry
@Component
struct Index {
  @State message: string = '';
  @State taskId: string = '';
  controller: TextAreaController = new TextAreaController();
  private baseContext: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  task: null | request.agent.Task = null;
  uploadTask: null | request.UploadTask = null;
  downloadTask: null | request.DownloadTask = null;
  url = 'https://gitee.com/chenzhixue/downloadTest/releases/download/v1.0/test.apk';
  urlProxy = 'http://192.168.43.248:808';

  index: number| undefined  = undefined;
  begins: number| undefined = undefined;
  ends: number| undefined  = undefined;

  pauseCallback = (pro: request.agent.Progress) => {
    console.info("====>pauseOn success" + JSON.stringify(pro));
    this.message += `====>pauseOn success pro: ${JSON.stringify(pro)} \n`
    this.controller.caretPosition(this.message.length);
  }

  resumeCallback = (pro: request.agent.Progress) => {
    console.info("====>resumeCallback success" + JSON.stringify(pro));
    this.message += `====>resumeCallback success pro: ${JSON.stringify(pro)} \n`
    this.controller.caretPosition(this.message.length);
  }

  removeCallback = (pro: request.agent.Progress) => {
    console.info("====>removeCallback success" + JSON.stringify(pro));
    this.message += `====>removeCallback success pro: ${JSON.stringify(pro)} \n`
    this.controller.caretPosition(this.message.length);
  }

  responseCallback = (pro: request.agent.HttpResponse) => {
    console.info("====>responseCallback" + JSON.stringify(pro));
    this.message += `====>responseCallback success pro: ${JSON.stringify(pro)} \n`
    this.controller.caretPosition(this.message.length);
  }

  build() {
    Row() {
      Column() {
        TextArea({
          text: this.message,
          placeholder: 'The text area can hold an unlimited amount of text. input your word...',
          controller: this.controller,
        })
          .placeholderColor(Color.Grey)
          .placeholderFont({size: 14, weight: 400})
          .caretColor(Color.Blue)
          .width('100%')
          .height('45%')
          .margin(20)
          .fontSize(14)
          .focusable(true)
          .fontColor(Color.Black)
          .enableKeyboardOnFocus(false)
          .defaultFocus(true)
          .margin({ top: '1%' })
        Flex({ justifyContent: FlexAlign.Center, wrap: FlexWrap.Wrap}) {

          Button('back')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              router.back();
            })

          Button('下载')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.downloadTaskTest()
            })

          Button('proxy下载')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.downloadProxyTaskTest()
            })

          Button('start')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.startTask()
            })

          Button('pause')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.pauseTask();
            })

          Button('resume')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.resumeTask();
            })

          Button('remove')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.removeTask();
            })

          Button('pauseTaskOffOrder')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.pauseTaskOffOrder();
            })

          Button('pauseOn')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.pauseTaskOn();
            })

          Button('pauseOffDes')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.pauseTaskOffDes();
            })

          Button('pauseOffAll')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.pauseTaskOffAll()
            })

          Button('resumeOn')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.resumeTaskOn()
            })

          Button('resumeOffDes')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.resumeTaskOffDes();
            })

          Button('resumeOffAll')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.resumeTaskOffAll();
            })

          Button('removeOn')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.removeTaskOn();
            })

          Button('removeOffDes')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.removeTaskOffDes()
            })

          Button('removeOffAll')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.removeTaskOffAll();
            })

          Button('responseOn')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.responseTaskOn()
            })

          Button('responseOffDes')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.responseTaskOffDes();
            })

          Button('responseOffAll')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.responseTaskOffAll();
            })

          Button('清屏')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.message = '';
            })
        }
        .width('100%')
      }
      .width('100%')
    }
    .height('100%')
  }

  async sleep(timeout: number): Promise<number> {
    return new Promise(resolve => {
      const st = setTimeout(() => {
        resolve(123);
        clearTimeout(st);
      }, timeout);
    });
  };

  async downloadTaskTest() {
    let config: request.agent.Config = {
      action: request.agent.Action.DOWNLOAD,
      url: this.url,
      title: 'reeateTest',
      description: 'XTS download test!',
      saveas: './downloadTaskTest.txt',
      overwrite: true,
      network: request.agent.Network.ANY,
      mode: request.agent.Mode.FOREGROUND,
    };
    let task = await request.agent.create(this.baseContext, config)
    this.task = task;
    this.message += `====>downloadTest create successs: ${JSON.stringify(config)} \n`
    this.controller.caretPosition(this.message.length);
  }

  async downloadProxyTaskTest() {
    let config: request.agent.Config = {
      action: request.agent.Action.DOWNLOAD,
      url: this.url,
      title: 'reeateTest',
      description: 'XTS download test!',
      saveas: './downloadProxyTaskTest.txt',
      overwrite: true,
      proxy: this.urlProxy,
      network: request.agent.Network.ANY,
      mode: request.agent.Mode.FOREGROUND,
    };
    let task = await request.agent.create(this.baseContext, config)
    this.task= task;
    this.message += `====>downloadProxyTaskTest create successs: ${JSON.stringify(config)} \n`
    this.controller.caretPosition(this.message.length);
  }

  async startTask(){
    if(this.task !== null){
      try{
        await this.task.start();
        console.info("====>startTask success");
        this.message += `====>startTask success tid: ${this.task.tid} \n`
        this.controller.caretPosition(this.message.length);
      }catch (err){
        console.info("====>startTask err: " + JSON.stringify(err));
      }
    }else{
      console.info("====>task is null， places check ");
    }
  }

  async pauseTask(){
    if(this.task !== null){
      try{
        await this.task.pause();
        console.info("====>pause success");
        this.message += `====>pause success tid: ${this.task.tid} \n`
        this.controller.caretPosition(this.message.length);
      }catch (err){
        console.info("====>pause err: " + JSON.stringify(err));
      }
    }else{
      console.info("====>task is null， places check ");
    }
  }

  async resumeTask(){
    if(this.task !== null){
      try{
        await this.task.resume();
        console.info("====>resume success");
        this.message += `====>resume success tid: ${this.task.tid} \n`
        this.controller.caretPosition(this.message.length);
      }catch (err){
        console.info("====>resume err: " + JSON.stringify(err));
      }
    }else{
      console.info("====>task is null， places check ");
    }
  }

  async removeTask(){
    if(this.task !== null){
      try{
        await request.agent.remove(this.task.tid);
        console.info("====>remove success");
        this.message += `====>remove success tid: ${this.task.tid} \n`
        this.controller.caretPosition(this.message.length);
      }catch (err){
        console.info("====>remove err: " + JSON.stringify(err));
      }
    }else{
      console.info("====>task is null， places check ");
    }
  }

  async pauseTaskOn(){
    if(this.task !== null){
      try{
        this.task.on('pause', this.pauseCallback);
        console.info("====>pauseOn start");
        this.message += `====>pauseOn start\n`
        this.controller.caretPosition(this.message.length);
      }catch (err){
        console.info("====>pauseOn err: " + JSON.stringify(err));
      }
    }else{
      console.info("====>task is null， places check ");
    }
  }
  async pauseTaskOffDes(){
    if(this.task !== null){
      try{
        this.task.off('pause', this.pauseCallback);
        console.info("====>pauseTaskOffDes start");
        this.message += `====>pauseTaskOffDes start\n`
        this.controller.caretPosition(this.message.length);
      }catch (err){
        console.info("====>pauseTaskOffDes err: " + JSON.stringify(err));
      }
    }else{
      console.info("====>task is null， places check ");
    }
  }
  async pauseTaskOffAll(){
    if(this.task !== null){
      try{
        this.task.off('pause');
        console.info("====>pauseTaskOffAll start");
        this.message += `====>pauseTaskOffAll start\n`
        this.controller.caretPosition(this.message.length);
      }catch (err){
        console.info("====>pauseTaskOffAll err: " + JSON.stringify(err));
      }
    }else{
      console.info("====>task is null， places check ");
    }
  }

  async resumeTaskOn(){
    if(this.task !== null){
      try{
        this.task.on('resume', this.resumeCallback);
        console.info("====>resumeTaskOn start");
        this.message += `====>resumeTaskOn start\n`
        this.controller.caretPosition(this.message.length);
      }catch (err){
        console.info("====>resumeTaskOn err: " + JSON.stringify(err));
      }
    }else{
      console.info("====>task is null， places check ");
    }
  }
  async resumeTaskOffDes(){
    if(this.task !== null){
      try{
        this.task.off('resume', this.resumeCallback);
        console.info("====>resumeTaskOffDes start");
        this.message += `====>resumeTaskOffDes start\n`
        this.controller.caretPosition(this.message.length);
      }catch (err){
        console.info("====>resumeTaskOffDes err: " + JSON.stringify(err));
      }
    }else{
      console.info("====>task is null， places check ");
    }
  }
  async resumeTaskOffAll(){
    if(this.task !== null){
      try{
        this.task.off('resume');
        console.info("====>resumeTaskOffAll start");
        this.message += `====>resumeTaskOffAll start\n`
        this.controller.caretPosition(this.message.length);
      }catch (err){
        console.info("====>pauseTaskOffAll err: " + JSON.stringify(err));
      }
    }else{
      console.info("====>task is null， places check ");
    }
  }

  async removeTaskOn(){
    if(this.task !== null){
      try{
        this.task.on('remove', this.removeCallback);
        console.info("====>removeTaskOn start");
        this.message += `====>removeTaskOn start\n`
        this.controller.caretPosition(this.message.length);
      }catch (err){
        console.info("====>removeTaskOn err: " + JSON.stringify(err));
      }
    }else{
      console.info("====>task is null， places check ");
    }
  }
  async removeTaskOffDes(){
    if(this.task !== null){
      try{
        this.task.off('remove', this.removeCallback);
        console.info("====>removeTaskOffDes start");
        this.message += `====>removeTaskOffDes start\n`
        this.controller.caretPosition(this.message.length);
      }catch (err){
        console.info("====>removeTaskOffDes err: " + JSON.stringify(err));
      }
    }else{
      console.info("====>task is null， places check ");
    }
  }
  async removeTaskOffAll(){
    if(this.task !== null){
      try{
        this.task.off('remove');
        console.info("====>removeTaskOffAll start");
        this.message += `====>removeTaskOffAll start\n`
        this.controller.caretPosition(this.message.length);
      }catch (err){
        console.info("====>removeTaskOffAll err: " + JSON.stringify(err));
      }
    }else{
      console.info("====>task is null， places check ");
    }
  }

  async responseTaskOn(){
    if(this.task !== null){
      try{
        this.task.on('response', this.responseCallback);
        console.info("====>responseTaskOn start");
        this.message += `====>responseTaskOn start\n`
        this.controller.caretPosition(this.message.length);
      }catch (err){
        console.info("====>responseTaskOn err: " + JSON.stringify(err));
      }
    }else{
      console.info("====>task is null， places check ");
    }
  }
  async responseTaskOffDes(){
    if(this.task !== null){
      try{
        this.task.off('response', this.responseCallback);
        console.info("====>responseTaskOffDes start");
        this.message += `====>responseTaskOffDes start\n`
        this.controller.caretPosition(this.message.length);
      }catch (err){
        console.info("====>responseTaskOffDes err: " + JSON.stringify(err));
      }
    }else{
      console.info("====>task is null， places check ");
    }
  }
  async responseTaskOffAll(){
    if(this.task !== null){
      try{
        this.task.off('response');
        console.info("====>responseTaskOffAll start");
        this.message += `====>responseTaskOffAll start\n`
        this.controller.caretPosition(this.message.length);
      }catch (err){
        console.info("====>responseTaskOffAll err: " + JSON.stringify(err));
      }
    }else{
      console.info("====>task is null， places check ");
    }
  }

  async pauseTaskOffOrder(){
    console.info('====>-----------------------pauseTaskOffOrder is starting-----------------------');
    let config: request.agent.Config = {
      action: request.agent.Action.DOWNLOAD,
      //url: 'https://gitee.com/chenzhixue/downloadTest/releases/download/v1.0/test.apk',
      url: this.url,
      title: 'reeateTest',
      description: 'XTS download test!',
      saveas: './pauseTaskOffOrder.txt',
      overwrite: true,
      network: request.agent.Network.ANY,
    };
    let arr: Array<number> = new Array();
    let arr1 = [0, 1, 2];
    try {
      request.agent.create(this.baseContext, config, async (err, task) => {
        if (err) {
          console.info("====>pauseTaskOffOrder create err: " + JSON.stringify(err));
          expect().assertFail();
        }
        let pro1 = (task1: request.agent.Progress) => {
          task.off('pause', pro1)
          console.info("====>pauseTaskOffOrder pro1: " + JSON.stringify(task1));
          arr.push(0);
        }

        let pro2 = (task2: request.agent.Progress) => {
          task.off('pause', pro2)
          console.info("====>pauseTaskOffOrder pro2: " + JSON.stringify(task2));
          arr.push(1);
        }

        let pro3 = async (task3: request.agent.Progress) => {
          try {
            task.off('pause', pro3)
            console.info("====>pauseTaskOffOrder pro3: " + JSON.stringify(task3));
            arr.push(2);
            console.info("====>pauseTaskOffOrder task3 pause on arr: " + JSON.stringify(arr));
            expect(arr.join()).assertEqual(arr1.join());
            try {
              await request.agent.remove(task.tid);
            } catch (err) {
              console.info('====>pauseTaskOffOrder task not remove: ' + JSON.stringify(task.tid));
            }
          } catch (err) {
            console.info("====>pauseTaskOffOrder catch err: " + JSON.stringify(err));
          }
        }
        task.on('pause', pro1);
        task.on('pause', pro2);
        task.on('pause', pro3);
        task.start(async (err) =>{
          try {
            if(err){
              console.info('====>pauseTaskOffOrder task.start err' + JSON.stringify(err));
              expect().assertFail();
            }
            await this.sleep(1500)
            await task.pause();
            console.info('====>pauseTaskOffOrder task.start success');
          } catch (err) {
            console.info('====>pauseTaskOffOrder task start failed: ' + JSON.stringify(err));
          }
        });
        console.info("====>pauseTaskOffOrder task.start");
      });
    } catch (err) {
      console.info("====>pauseTaskOffOrder create catch err: " + JSON.stringify(err));
    }
  }
}
