import { Contexts } from './utils/Contexts';
import { HiLog } from './utils/HiLog';
import { Log } from './utils/Log';

export class InitCommon {
  static hasInit: boolean = false;
  static init(context: Context, debug: boolean) {
    if (InitCommon.hasInit) {
      Log.error('InitCommon 已经初始化，请勿重复初始化！')
      return
    }
    Contexts.setContext(context)
    Log.setShowLog(debug)
    HiLog.setShowLog(debug)
    Log.info('InitCommon.init()');
    InitCommon.hasInit = true
  }
}