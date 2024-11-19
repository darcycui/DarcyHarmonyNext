import { hilog } from '@kit.PerformanceAnalysisKit';

let DOMAIN_NUMBER = 0xFF00;
let TAG = "DarcyLog";

export class HiLog {
  private static showLog: boolean = false;

  static setShowLog(showLog: boolean) {
    HiLog.showLog = showLog;
  }

  static isShowLog(): boolean {
    return HiLog.showLog
  }

  static info(msg: string) {
    if (HiLog.isShowLog()) {

      hilog.info(DOMAIN_NUMBER, TAG, msg);
    }
  }

  static debug(msg: string) {
    if (HiLog.isShowLog()) {
      hilog.debug(DOMAIN_NUMBER, TAG, msg);
    }
  }

  static warn(msg: string) {
    if (HiLog.isShowLog()) {
      hilog.warn(DOMAIN_NUMBER, TAG, msg);
    }
  }

  static error(msg: string) {
    if (HiLog.isShowLog()) {
      hilog.error(DOMAIN_NUMBER, TAG, msg);
    }
  }

  static fatal(msg: string) {
    if (HiLog.isShowLog()) {
      hilog.fatal(DOMAIN_NUMBER, TAG, msg);
    }
  }
}