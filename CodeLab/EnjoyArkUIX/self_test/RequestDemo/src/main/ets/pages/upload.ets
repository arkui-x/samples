import { BusinessError, request } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import fs from '@ohos.file.fs';
import fileIo from '@ohos.file.fs';
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
  url = 'http://192.168.43.248:8080/hfs/';
  urlProxy = 'http://192.168.43.248:808';

  index: number| undefined  = undefined;
  begins: number| undefined = undefined;
  ends: number| undefined  = undefined;

  pauseCallback = (pro: request.agent.Progress) => {
    console.info("====>pauseOn success" + JSON.stringify(pro));
    this.message += `====>pauseOn success tid: ${JSON.stringify(pro)} \n`
    this.controller.caretPosition(this.message.length);
  }

  resumeCallback = (pro: request.agent.Progress) => {
    console.info("====>resumeCallback success" + JSON.stringify(pro));
    this.message += `====>resumeCallback success tid: ${JSON.stringify(pro)} \n`
    this.controller.caretPosition(this.message.length);
  }

  removeCallback = (pro: request.agent.Progress) => {
    console.info("====>removeCallback success" + JSON.stringify(pro));
    this.message += `====>removeCallback success tid: ${JSON.stringify(pro)} \n`
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
          TextInput({ placeholder: '输入index，默认为undefined'})
            .width('33%')
            .height(45)
            .type(InputType.Normal)
            .onChange((value) => {
              if (value === 'undefined') {
                this.index = undefined
              } else{
                this.index = parseInt(value)
              }
            })
          TextInput({ placeholder: '输入begins，默认为undefined'})
            .width('33%')
            .height(45)
            .type(InputType.Normal)
            .onChange((value) => {
              if (value === 'undefined') {
                this.begins = undefined
              }else{
                this.begins = parseInt(value)
              }
            })
          TextInput({ placeholder: '输入ends，默认为undefined'})
            .width('33%')
            .height(45)
            .type(InputType.Normal)
            .onChange((value) => {
              if (value === 'undefined') {
                this.ends = undefined
              } else {
                this.ends = parseInt(value)
              }
            })
          Button('API9单文件上传')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.uploadTestApi9()
            })

          Button('API9多文件上传')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.uploadMiltTestApi9()
            })

          Button('API10单文件上传')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.uploadTestApi10()
            })

          Button('API10多文件上传')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.uploadMiltTestApi10()
            })

          Button('proxy上传')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.uploadTestProxyApi10()
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

          Button('清屏')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.message = '';
            })

          Button('back')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              router.back();
            })
        }
        .width('100%')
      }
      .width('100%')
    }
    .height('100%')
  }
  async uploadTestApi9() {
    let wenBen: string =
      'Create tasks for upload or download and queue them.' +
        'Create tasks for upload or download and queue them.' +
        'Create tasks for upload or download and queue them.';

    let file1: fs.File = fs.openSync(this.baseContext.cacheDir + '/test1.txt', 0o100 | 0o2);
    try {
      for (let i = 0; i < 1; i++) {
        fs.writeSync(file1.fd, wenBen);
      }
    } finally {
      fs.closeSync(file1.fd);
    }

    let stat = fileIo.statSync(this.baseContext.cacheDir + "/test1.txt");
    console.info(`====>upload_text size: ` + stat.size);

    let uploadFile1: request.File = {
      filename: 'test1.txt',
      name: 'file',
      uri: this.baseContext.cacheDir + '/test1.txt',
      type: 'txt'
    };

    let uploadConfig: request.UploadConfig = {
      url: this.url,
      header: {
        'Content-Type': 'multipart/form-data',
        'Accept': '*/*',
      },
      method: 'POST',
      files: [uploadFile1],
      data: [],
      index: this.index,
      begins:this.begins,
      ends: this.ends
    };
    console.info("====>uploadTestApi9 config: " + JSON.stringify(uploadConfig));
    this.message += `====>uploadTestApi9 config: ${JSON.stringify(uploadConfig)} \n`
    this.controller.caretPosition(this.message.length);
    request.uploadFile(this.baseContext, uploadConfig, async (err, task) => {
      try{
        if (err) {
          console.info("====>uploadTestApi9 create err: " + JSON.stringify(err));
        }
        task.on("complete", (progress) => {
          task.off("complete");
          console.info('====>uploadTestApi9 upload task success.' + JSON.stringify(progress));
        });
      }catch(err){
        console.info("====>uploadTestApi9 create err: " + JSON.stringify(err));
      }
    });
  }

  async uploadMiltTestApi9() {
    let wenBen: string =
      'Create tasks for upload or download and queue them.' +
        'Create tasks for upload or download and queue them.' +
        'Create tasks for upload or download and queue them.';

    let file1: fs.File = fs.openSync(this.baseContext.cacheDir + '/test1.txt', 0o100 | 0o2);
    try {
      for (let i = 0; i < 1; i++) {
        fs.writeSync(file1.fd, wenBen);
      }
    } finally {
      fs.closeSync(file1.fd);
    }
    let file2: fs.File = fs.openSync(this.baseContext.cacheDir + '/test2.txt', 0o100 | 0o2);
    try {
      for (let i = 0; i < 1; i++) {
        fs.writeSync(file2.fd, wenBen);
      }
    } finally {
      fs.closeSync(file2.fd);
    }
    let file3: fs.File = fs.openSync(this.baseContext.cacheDir + '/test3.txt', 0o100 | 0o2);
    try {
      for (let i = 0; i < 1; i++) {
        fs.writeSync(file3.fd, wenBen);
      }
    } finally {
      fs.closeSync(file3.fd);
    }
    let file4: fs.File = fs.openSync(this.baseContext.cacheDir + '/test4.txt', 0o100 | 0o2);
    try {
      for (let i = 0; i < 1; i++) {
        fs.writeSync(file4.fd, wenBen);
      }
    } finally {
      fs.closeSync(file4.fd);
    }
    // fs.truncateSync(file.fd, 0);
    let stat = fileIo.statSync(this.baseContext.cacheDir + "/test1.txt");
    console.info(`====>upload_text size: ` + stat.size);

    let uploadFile1: request.File = {
      filename: 'test1.txt',
      name: 'file',
      uri: this.baseContext.cacheDir + '/test1.txt',
      type: 'txt'
    };
    let uploadFile2: request.File = {
      filename: 'test2.txt',
      name: 'file',
      uri: this.baseContext.cacheDir + '/test2.txt',
      type: 'txt'
    };
    let uploadFile3: request.File = {
      filename: 'test3.txt',
      name: 'file',
      uri: this.baseContext.cacheDir + '/test3.txt',
      type: 'txt'
    };
    let uploadFile4: request.File = {
      filename: 'test4.txt',
      name: 'file',
      uri: this.baseContext.cacheDir + '/test4.txt',
      type: 'txt'
    };

    let uploadConfig: request.UploadConfig = {
      url: this.url,
      header: {
        'Content-Type': 'multipart/form-data',
        'Accept': '*/*',
      },
      method: 'POST',
      files: [uploadFile1, uploadFile2, uploadFile3,uploadFile4],
      data: [],
      index: this.index,
      begins:this.begins,
      ends: this.ends
    };
    console.info("====>uploadMiltTestApi9 config: " + JSON.stringify(uploadConfig));
    this.message += `====>uploadMiltTestApi9 config: ${JSON.stringify(uploadConfig)} \n`
    this.controller.caretPosition(this.message.length);
    request.uploadFile(this.baseContext, uploadConfig, async (err, task) => {
      task.on("complete", (progress) => {
        task.off("complete");
        console.info('====>uploadMiltTestApi9 upload task success.' + JSON.stringify(progress));
      });
      try{
        if (err) {
          console.info("====>uploadMiltTestApi9 create err: " + JSON.stringify(err));
        }
      }catch(err){
        console.info("====>uploadMiltTestApi9 create err: " + JSON.stringify(err));
      }
    });
  }

  async uploadTestApi10() {
    let wenBen: string =
      'Create tasks for upload or download and queue them.' +
        'Create tasks for upload or download and queue them.' +
        'Create tasks for upload or download and queue them.';

    let file1: fs.File = fs.openSync(this.baseContext.cacheDir + '/test1.txt', 0o100 | 0o2);
    try {
      for (let i = 0; i < 155344; i++) {
        fs.writeSync(file1.fd, wenBen);
      }
    } finally {
      fs.closeSync(file1.fd);
    }
    // fs.truncateSync(file.fd, 0);
    let stat = fileIo.statSync(this.baseContext.cacheDir + "/test1.txt");
    console.info(`====>upload_text size: ` + stat.size);

    let attachments: Array<request.agent.FormItem> = [{
      name: "file",
      value: [
        {
          filename: "ios_upload_text1.txt",
          mimeType: "application/octet-stream",
          path: "./test1.txt",
        }
      ]
    }];
    let config: request.agent.Config = {
      action: request.agent.Action.UPLOAD,
      url: this.url,
      title: 'uploadTest',
      description: 'Sample code for event listening',
      mode: request.agent.Mode.FOREGROUND,
      overwrite: true,
      method: "POST",
      data: attachments,
      saveas: "./",
      network: request.agent.Network.ANY,
      metered: false,
      roaming: true,
      retry: true,
      redirect: true,
      index: this.index,
      begins: this.begins,
      ends: this.ends,
      gauge: false,
      precise: false,
      token: "it is a secret"
    };
    console.info("====>uploadTestApi10 config: " + JSON.stringify(config));
    this.message += `====>uploadTestApi10 config: ${JSON.stringify(config)} \n`
    this.controller.caretPosition(this.message.length);
    request.agent.create(this.baseContext, config, async (err, task) => {
      this.task = task;
      try{
        if (err) {
          console.info("====>uploadTestApi10 create err: " + JSON.stringify(err));
        }
        task.on("completed", (progress) => {
          task.off("completed");
          console.info('====>uploadTestApi10 upload task success.' + JSON.stringify(progress));
        });
        await task.start();
      }catch(err){
        console.info("====>uploadTestApi10 create err: " + JSON.stringify(err));
      }
    });

  }

  async uploadTestProxyApi10() {
    let wenBen: string =
      'Create tasks for upload or download and queue them.' +
        'Create tasks for upload or download and queue them.' +
        'Create tasks for upload or download and queue them.';

    let file1: fs.File = fs.openSync(this.baseContext.cacheDir + '/test1.txt', 0o100 | 0o2);
    try {
      for (let i = 0; i < 1; i++) {
        fs.writeSync(file1.fd, wenBen);
      }
    } finally {
      fs.closeSync(file1.fd);
    }
    // fs.truncateSync(file.fd, 0);
    let stat = fileIo.statSync(this.baseContext.cacheDir + "/test1.txt");
    console.info(`====>upload_text size: ` + stat.size);

    let attachments: Array<request.agent.FormItem> = [{
      name: "file",
      value: [
        {
          filename: "ios_upload_text1.txt",
          mimeType: "application/octet-stream",
          path: "./test1.txt",
        }
      ]
    }];
    let config: request.agent.Config = {
      action: request.agent.Action.UPLOAD,
      url: this.url,
      title: 'uploadTest',
      description: 'Sample code for event listening',
      mode: request.agent.Mode.FOREGROUND,
      overwrite: true,
      method: "POST",
      data: attachments,
      saveas: "./",
      network: request.agent.Network.ANY,
      metered: false,
      roaming: true,
      retry: true,
      redirect: true,
      index: this.index,
      begins: this.begins,
      ends: this.ends,
      gauge: false,
      precise: false,
      proxy: this.urlProxy,
      token: "it is a secret"
    };
    console.info("====>uploadTestApi10 config: " + JSON.stringify(config));
    this.message += `====>uploadTestApi10 config: ${JSON.stringify(config)} \n`
    this.controller.caretPosition(this.message.length);
    request.agent.create(this.baseContext, config, async (err, task) => {
      this.task = task
      try{
        if (err) {
          console.info("====>uploadTestApi10 create err: " + JSON.stringify(err));
        }
        task.on("completed", (progress) => {
          task.off("completed");
          console.info('====>uploadTestApi10 upload task success.' + JSON.stringify(progress));
        });
        await task.start();
      }catch(err){
        console.info("====>uploadTestApi10 create err: " + JSON.stringify(err));
      }
    });

  }

  async uploadMiltTestApi10() {
    let wenBen: string =
      'Create tasks for upload or download and queue them.' +
        'Create tasks for upload or download and queue them.' +
        'Create tasks for upload or download and queue them.';

    let file1: fs.File = fs.openSync(this.baseContext.cacheDir + '/test1.txt', 0o100 | 0o2);
    try {
      for (let i = 0; i < 1; i++) {
        fs.writeSync(file1.fd, wenBen);
      }
    } finally {
      fs.closeSync(file1.fd);
    }
    let file2: fs.File = fs.openSync(this.baseContext.cacheDir + '/test2.txt', 0o100 | 0o2);
    try {
      for (let i = 0; i < 1; i++) {
        fs.writeSync(file2.fd, wenBen);
      }
    } finally {
      fs.closeSync(file2.fd);
    }
    let file3: fs.File = fs.openSync(this.baseContext.cacheDir + '/test3.txt', 0o100 | 0o2);
    try {
      for (let i = 0; i < 1; i++) {
        fs.writeSync(file3.fd, wenBen);
      }
    } finally {
      fs.closeSync(file3.fd);
    }
    let file4: fs.File = fs.openSync(this.baseContext.cacheDir + '/test4.txt', 0o100 | 0o2);
    try {
      for (let i = 0; i < 1; i++) {
        fs.writeSync(file4.fd, wenBen);
      }
    } finally {
      fs.closeSync(file4.fd);
    }
    // fs.truncateSync(file.fd, 0);
    let stat = fileIo.statSync(this.baseContext.cacheDir + "/test1.txt");
    console.info(`====>upload_text size: ` + stat.size);

    let attachments: Array<request.agent.FormItem> = [{
      name: "file",
      value: [
        {
          filename: "ios_upload_text1.txt",
          mimeType: "application/octet-stream",
          path: "./test1.txt",
        },
        {
          filename: "ios_upload_text2.txt",
          mimeType: "application/octet-stream",
          path: "./test2.txt",
        },
        {
          filename: "ios_upload_text3.txt",
          mimeType: "application/octet-stream",
          path: "./test3.txt",
        },
        {
          filename: "ios_upload_text4.txt",
          mimeType: "application/octet-stream",
          path: "./test4.txt",
        },
      ]
    }];
    let config: request.agent.Config = {
      action: request.agent.Action.UPLOAD,
      url: this.url,
      title: 'uploadTest',
      description: 'Sample code for event listening',
      mode: request.agent.Mode.FOREGROUND,
      overwrite: true,
      method: "POST",
      data: attachments,
      saveas: "./",
      network: request.agent.Network.ANY,
      metered: false,
      roaming: true,
      retry: true,
      redirect: true,
      index: this.index,
      begins: this.begins,
      ends: this.ends,
      gauge: false,
      precise: false,
      token: "it is a secret"
    };
    console.info("====>uploadMiltTestApi10 config: " + JSON.stringify(config));
    this.message += `====>uploadMiltTestApi10 config: ${JSON.stringify(config)} \n`
    this.controller.caretPosition(this.message.length);
    request.agent.create(this.baseContext, config, async (err, task) => {
      this.task = task;
      try{
        if (err) {
          console.info("====>uploadMiltTestApi10 create err: " + JSON.stringify(err));
        }
        task.on("completed", (progress) => {
          task.off("completed");
          console.info('====>uploadMiltTestApi10 upload task success.' + JSON.stringify(progress));
        });
        await task.start();
      }catch(err){
        console.info("====>uploadMiltTestApi10 create err: " + JSON.stringify(err));
      }
    });
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
}
