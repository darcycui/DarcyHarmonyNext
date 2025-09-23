// NormalTextListExample.h
// 自定义NDK接口入口函数 实现文本列表UI

#ifndef MYAPPLICATION_NORMALTEXTLISTEXAMPLE_H
#define MYAPPLICATION_NORMALTEXTLISTEXAMPLE_H

#include "ArkUIBaseNode.h"
#include "ArkUIListItemNode.h"
#include "ArkUIListNode.h"
#include "ArkUITextNode.h"
#include <hilog/log.h>

namespace NativeModule {

// 实现文本列表UI
std::shared_ptr<ArkUIBaseNode> CreateTextListExample() {
    // 创建组件并挂载
    // 1：使用智能指针创建List组件。
    auto list = std::make_shared<ArkUIListNode>();
    list->SetPercentWidth(1);
    list->SetPercentHeight(1);
    list->SetScrollBarState(true);
    // 2：创建ListItem子组件并挂载到List上。
    for (int32_t i = 0; i < 30; ++i) {
        auto listItem = std::make_shared<ArkUIListItemNode>();
        auto textNode = std::make_shared<ArkUITextNode>();
        textNode->SetTextContent(std::to_string(i));
        textNode->SetFontSize(16);
        textNode->SetFontColor(0xFFff00ff);
        textNode->SetPercentWidth(1);
        textNode->SetWidth(300);
        textNode->SetHeight(100);
        textNode->SetBackgroundColor(0xFFfffacd);
        textNode->SetTextAlign(ARKUI_TEXT_ALIGNMENT_CENTER);
        listItem->InsertChild(textNode, i);
        list->AddChild(listItem);
    }
    return list;
}
} // namespace NativeModule

#endif // MYAPPLICATION_NORMALTEXTLISTEXAMPLE_H