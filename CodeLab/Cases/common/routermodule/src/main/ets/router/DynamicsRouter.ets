/*
* Copyright (C) 2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { Interceptor } from '../interceptor/Interceptor';
import { HOME_PAGE, RouterConfig, AppRouterInfo } from '../model/AppRouterInfo';
import { Context } from '@kit.AbilityKit';
import { RouterLoader } from '../util/RouterLoader';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { logger } from 'utils';
import { display, window } from '@kit.ArkUI';

/**
 * 动态路由
 *
 * 实现步骤：
 * 1.将主模块的NavPathStack传入createRouter接口，注册路由
 * 2.通过registerBuilder接口，将需要动态加载的模块注册到路由中
 * 3.通过push接口，跳转到指定的模块页面
 */
const LOGGER_TAG: string = 'Dynamics import failed , reason : ';

// 路由跳转延时
const DELAY_TIME: number = 20;
// 默认手机窗口尺寸
export const DEFAULT_WINDOW_SIZE: window.Size = { width: 1280, height: 2580 };

export class DynamicsRouter {
  static config: RouterConfig;
  // 路由表信息
  static routerMap: Map<string, AppRouterInfo> = new Map();
  // 管理需要动态导入的模块，key是模块名，value是WrappedBuilder对象，动态调用创建页面的接口
  static builderMap: Map<string, WrappedBuilder<[object]>> = new Map<string, WrappedBuilder<[object]>>();
  static navPathStack: NavPathStack = new NavPathStack();
  // 自动生成的路由列表
  static appRouterStack: Array<AppRouterInfo> = new Array();
  static referrer: string[] = [];
  static fullScreenRoutes: string[] = []
  static timer: number = -1;

  // 初始化动态路由
  public static routerInit(config: RouterConfig, context: Context) {
    DynamicsRouter.config = config;
    DynamicsRouter.appRouterStack.push(HOME_PAGE);
    // 加载路由表
    RouterLoader.load(config.mapPath, DynamicsRouter.routerMap, context);
  }

  // 通过名称注册builder
  private static registerBuilder(builderName: string, builder: WrappedBuilder<[object]>): void {
    DynamicsRouter.builderMap.set(builderName, builder);
  }

  // 通过名称获取builder
  public static getBuilder(builderName: string): WrappedBuilder<[object]> {
    const builder = DynamicsRouter.builderMap.get(builderName);
    if (!builder) {
      const MSG = "not found builder";
      logger.info(MSG + builderName);
    }
    return builder as WrappedBuilder<[object]>;
  }

  // 通过名称获取router
  private static getNavPathStack(): NavPathStack {
    return DynamicsRouter.navPathStack;
  }

  // 获取路由来源页面栈
  public static getRouterReferrer(): string[] {
    return DynamicsRouter.referrer;
  }

  // 设置折叠屏下全屏路由信息
  public static setFullScreenRoutes(routes: string[]) {
    DynamicsRouter.fullScreenRoutes = routes;
  }

  // 根据路由信息跳转到对应的页面
  public static pushUri(name: string, param?: ESObject) {
    // 如果路由表中没有该路由信息，直接中断执行
    if (!DynamicsRouter.routerMap.has(name)) {
      return;
    }
    // 根据路由名获取路由信息
    let routerInfo: AppRouterInfo = DynamicsRouter.routerMap.get(name)!;
    // 如果是第一次跳转，则需要动态引入模块
    if (!DynamicsRouter.builderMap.has(name)) {
      // 动态引用模块，如“addressexchange”，和entry/oh-package.json中配置的模块名相同
      import(`${routerInfo.pageModule}`)
        .then((module: ESObject) => {
          // 通过路由注册方法注册路由
          module[routerInfo.registerFunction!](routerInfo);
          // TODO：知识点：在路由模块的动态路由.pushUri()中调用拦截方法，此处必须等待动态路由加载完成后再进行拦截，否则页面加载不成功，导致无法注册拦截的函数，出现首次拦截失效。
          if (Interceptor.interceptor(name, param)) {
            return;
          }
          // 跳转页面
          DynamicsRouter.navPathStack.pushPath({ name: name, param: param });
          DynamicsRouter.pushRouterStack(routerInfo);
        })
        .catch((error: BusinessError) => {
          logger.error(`promise import module failed, error code:${error.code}, message:${error.message}`);
        });
    } else {
      // TODO：知识点：除首次跳转后，之后的每次跳转都需进行路由拦截。
      if (Interceptor.interceptor(name, param)) {
        return;
      }
      // 如果已经跳转过，则直接跳转，不需要重新动态引用
      DynamicsRouter.navPathStack.pushPath({ name: name, param: param });
      DynamicsRouter.pushRouterStack(routerInfo);
    }
  }

  // 存储引用信息
  private static pushRouterStack(routerInfo: AppRouterInfo) {
    DynamicsRouter.appRouterStack.push(routerInfo);
    const referrerModel: AppRouterInfo = DynamicsRouter.appRouterStack[DynamicsRouter.appRouterStack.length-2];
    DynamicsRouter.referrer[0] = referrerModel.pageModule;
    DynamicsRouter.referrer[1] = referrerModel.name;
    logger.info(`From DynamicsRouter.routerStack push preview module name is ${DynamicsRouter.referrer[0]},path is ${DynamicsRouter.referrer[1]}`);
  }

  // 通过获取页面栈并pop
  public static popAppRouter(): void {
    // pop前记录的来源页为当前栈顶
    const referrerModel: AppRouterInfo = DynamicsRouter.appRouterStack[DynamicsRouter.appRouterStack.length - 1];
    DynamicsRouter.referrer[0] = referrerModel.pageModule;
    DynamicsRouter.referrer[1] = referrerModel.name;
    logger.info(`From DynamicsRouter.routerStack pop preview module name is + ${DynamicsRouter.referrer[0]}, path is ${DynamicsRouter.referrer[1]}`);
    if (DynamicsRouter.appRouterStack.length > 1) {
      DynamicsRouter.appRouterStack.pop();
    } else {
      logger.info("DynamicsRouter.routerStack is only Home.");
    }
    // 定义事件3
    let innerEvent: emitter.InnerEvent = {
      eventId: 3
    };
    let eventData: emitter.EventData = {
      data: {
        navMode: 3
      }
    };
    // 查找到对应的路由栈进行pop
    if(!DynamicsRouter.fullScreenRoutes.includes(DynamicsRouter.referrer[1]) && DynamicsRouter.getNavPathStack().size() === 1) {
      // 非全屏子路由宽屏条件下回到首页，Navigation的mode属性修改默认动画会与过场动画冲突，需关闭过场动画
      if (display.getDefaultDisplaySync().width > DEFAULT_WINDOW_SIZE.width) {
        DynamicsRouter.getNavPathStack().disableAnimation(true);
      }
      DynamicsRouter.timer = setTimeout(() => {
        // 触发EntryView下navMode改变
        emitter.emit(innerEvent, eventData);
      }, DELAY_TIME);
      DynamicsRouter.getNavPathStack().pop();
    }else if(DynamicsRouter.fullScreenRoutes.includes(DynamicsRouter.referrer[1])) {
      // 全屏子路由返回逻辑
      DynamicsRouter.getNavPathStack().pop();
      // 触发EntryView下navMode改变
      emitter.emit(innerEvent, eventData);
    }else {
      DynamicsRouter.getNavPathStack().pop();
    }
  }

  // 通过获取页面栈并将其清空
  public static clear(): void {
    // 查找到对应的路由栈进行pop
    DynamicsRouter.getNavPathStack().clear();
    DynamicsRouter.appRouterStack = [HOME_PAGE];
  }

  /**
   * 注册动态路由需要加载的页面，用于自动生成的路由
   *
   * @param pageName 页面名，需要动态加载的页面名称
   * @param wrapBuilder wrapBuilder对象
   */
  public static registerAppRouterPage(routerInfo: AppRouterInfo, wrapBuilder: WrappedBuilder<[object]>): void {
    const builderName: string = routerInfo.name;
    if (!DynamicsRouter.builderMap.has(builderName)) {
      DynamicsRouter.registerBuilder(builderName, wrapBuilder);
    }
  }
}