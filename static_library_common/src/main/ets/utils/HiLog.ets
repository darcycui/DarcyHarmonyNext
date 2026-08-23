import { hilog } from '@kit.PerformanceAnalysisKit';

let DOMAIN_NUMBER = 0xFF00;
let HILOG_TAG = "DarcyLog";

export class HiLog {
  private static showLog: boolean = true;

  static setShowLog(showLog: boolean) {
    HiLog.showLog = showLog;
  }

  static isShowLog(): boolean {
    return HiLog.showLog
  }

  static info(msg: string) {
    if (HiLog.isShowLog()) {
      hilog.info(DOMAIN_NUMBER, HILOG_TAG, msg);
    }
  }

  static debug(msg: string) {
    if (HiLog.isShowLog()) {
      hilog.debug(DOMAIN_NUMBER, HILOG_TAG, msg);
    }
  }

  static warn(msg: string) {
    if (HiLog.isShowLog()) {
      hilog.warn(DOMAIN_NUMBER, HILOG_TAG, msg);
    }
  }

  static error(msg: string) {
    if (HiLog.isShowLog()) {
      hilog.error(DOMAIN_NUMBER, HILOG_TAG, msg);
    }
  }

  static fatal(msg: string) {
    if (HiLog.isShowLog()) {
      hilog.fatal(DOMAIN_NUMBER, HILOG_TAG, msg);
    }
  }
}