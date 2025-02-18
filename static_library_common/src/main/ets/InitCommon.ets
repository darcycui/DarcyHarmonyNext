import { HiLog } from './utils/HiLog';
import { Log } from './utils/Log';

export class InitCommon {
  static hasInit: boolean = false;
  static init(debug: boolean) {
    if (InitCommon.hasInit) {
      return
    }
    Log.setShowLog(debug)
    HiLog.setShowLog(debug)
    Log.info('InitCommon.init()');
    InitCommon.hasInit = true
  }
}