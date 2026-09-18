/**
 * ConversationIntent - 会话页面意图定义
 *
 * 所有用户交互行为封装为 Intent，通过 dispatch 发送给 ViewModel。
 * ViewModel 根据 Intent 类型分发到对应处理方法。
 *
 * 架构流向：
 *   View → dispatch(ConversationIntent) → ViewModel
 */
import { IIntent } from 'static_library_common';

/**
 * 会话页面 Intent 基类
 */
export class ConversationIntent implements IIntent {}

/**
 * 获取会话列表 Intent
 * 页面初始化时触发
 */
export class FetchConversationListIntent extends ConversationIntent {}

/**
 * 刷新会话列表 Intent
 * 下拉刷新时触发
 */
export class RefreshConversationListIntent extends ConversationIntent {}
