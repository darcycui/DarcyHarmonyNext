// ArkUIListItemNode.h
// 提供列表项的封装类。

#ifndef MYAPPLICATION_ARKUISTACKNODE_H
#define MYAPPLICATION_ARKUISTACKNODE_H

#include "ArkUINode.h"

namespace NativeModule {
class ArkUIListItemNode : public ArkUINode {
public:
    ArkUIListItemNode()
        : ArkUINode((NativeModuleInstance::GetInstance()->GetNativeNodeAPI())->createNode(ARKUI_NODE_LIST_ITEM)) {}
};
} // namespace NativeModule

#endif // MYAPPLICATION_ARKUISTACKNODE_H