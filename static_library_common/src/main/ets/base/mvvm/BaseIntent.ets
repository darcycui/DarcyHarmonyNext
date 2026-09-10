/**
 * 通用 Intent 常量
 * 各页面可在此基础之上扩展
 */
export class BaseIntent {
  /** 加载数据 */
  static readonly LOAD = 'BASE_LOAD';
  /** 刷新数据 */
  static readonly REFRESH = 'BASE_REFRESH';
  /** 重置状态 */
  static readonly RESET = 'BASE_RESET';
  /** 清除错误 */
  static readonly CLEAR_ERROR = 'BASE_CLEAR_ERROR';
}