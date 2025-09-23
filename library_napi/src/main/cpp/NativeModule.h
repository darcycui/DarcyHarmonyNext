// NativeModule.h
// 提供获取ArkUI在Native侧模块的封装接口

#ifndef MYAPPLICATION_NATIVEMODULE_H
#define MYAPPLICATION_NATIVEMODULE_H

#include "napi/native_api.h"
#include <arkui/native_node.h>
#include <cassert>

#include <arkui/native_interface.h>

namespace NativeModule {

class NativeModuleInstance {
public:
    static NativeModuleInstance *GetInstance() {
        static NativeModuleInstance instance;
        return &instance;
    }

    NativeModuleInstance() {
        // 获取NDK接口的函数指针结构体对象，用于后续操作。
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, arkUINativeNodeApi_);
        assert(arkUINativeNodeApi_);
    }
    // 暴露给其他模块使用。
    ArkUI_NativeNodeAPI_1 *GetNativeNodeAPI() { return arkUINativeNodeApi_; }

private:
    ArkUI_NativeNodeAPI_1 *arkUINativeNodeApi_ = nullptr;
};

} // namespace NativeModule

#endif // MYAPPLICATION_NATIVEMODULE_H