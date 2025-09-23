// NativeEntry.cpp UI实现类
// 创建UI
// 销毁UI

#include <arkui/native_node_napi.h>
#include <hilog/log.h>
#include <js_native_api.h>
#include "NativeEntry.h"
#include "NormalTextListExample.h"

namespace NativeModule {

// 创建UI
napi_value CreateNativeRoot(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取NodeContent
    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    NativeEntry::GetInstance()->SetContentHandle(contentHandle);

    // 创建文本列表
    auto list = CreateTextListExample();

    // 保持Native侧对象到管理类中，维护生命周期。
    NativeEntry::GetInstance()->SetRootNode(list);
    return nullptr;
}

// 销毁UI
napi_value DestroyNativeRoot(napi_env env, napi_callback_info info) {
    // 从管理类中释放Native侧对象。
    NativeEntry::GetInstance()->DisposeRootNode();
    return nullptr;
}

} // namespace NativeModule