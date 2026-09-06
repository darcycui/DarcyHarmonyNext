import { Log } from "./Log"

export class Contexts {
  static context: Context | null = null

  static setContext(context: Context) {
    Contexts.context = context
  }

  static getContext(): Context {
    if (Contexts.context == null) {
      Log.error('获取上下文Context错误, 请先调用 setContext() 设置上下文')
      throw new Error('获取上下文Context错误, 请先调用 setContext() 设置上下文')
    }
    return Contexts.context
  }
}