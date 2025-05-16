/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "test_plugin_impl.h"

#include <memory>

// libarkui_ios中的plugin_utils.h定义了插件注册常用的接口
#include <libarkui_ios/include/plugin_utils.h>

#import "ios_test_plugin.h"

std::unique_ptr<TestPlugin> TestPlugin::Create()
{
    return std::make_unique<TestPluginImpl>();
}

void TestPluginImpl::Log(std::string log)
{
    NSString* ocLog = [NSString stringWithCString:log.c_str() encoding:NSUTF8StringEncoding];
    [[iOSTestPlugin shareinstance] log: ocLog];
}
