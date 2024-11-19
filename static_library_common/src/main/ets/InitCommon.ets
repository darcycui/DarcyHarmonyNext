import { HiLog } from './utils/HiLog';
import { Log } from './utils/Log';

export class InitCommon {
  static init(debug: boolean) {
    Log.setShowLog(debug)
    HiLog.setShowLog(debug)
    Log.info('InitCommon.init()');
  }
}