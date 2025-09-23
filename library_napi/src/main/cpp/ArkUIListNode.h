// ArkUIListNode.h
// 提供列表组件的封装。

#ifndef MYAPPLICATION_ARKUILISTNODE_H
#define MYAPPLICATION_ARKUILISTNODE_H

#include "ArkUINode.h"

namespace NativeModule {
class ArkUIListNode : public ArkUINode {
public:
    ArkUIListNode()
        : ArkUINode((NativeModuleInstance::GetInstance()->GetNativeNodeAPI())->createNode(ARKUI_NODE_LIST)) {} // 创建ArkUI的列表组件。

    ~ArkUIListNode() override {} 
    // List组件的属性NDK接口封装。
    void SetScrollBarState(bool isShow) {
        assert(handle_);
        ArkUI_ScrollBarDisplayMode displayMode =
            isShow ? ARKUI_SCROLL_BAR_DISPLAY_MODE_ON : ARKUI_SCROLL_BAR_DISPLAY_MODE_OFF;
        ArkUI_NumberValue value[] = {{.i32 = displayMode}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_SCROLL_BAR_DISPLAY_MODE, &item);
    }
};
} // namespace NativeModule

#endif // MYAPPLICATION_ARKUILISTNODE_H