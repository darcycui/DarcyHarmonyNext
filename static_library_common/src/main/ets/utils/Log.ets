// library/src/main/ts/test.ets

let LOG_TAG = "DarcyLog";

export class Log {
  // private static showLog: boolean = false;
  private static showLog: boolean = true;

  static setShowLog(showLog: boolean) {
    Log.showLog = showLog;
  }

  static isShowLog(): boolean {
    return Log.showLog
  }

  static info(msg: string) {
    if (Log.isShowLog()) {
      console.info(`${LOG_TAG} ${msg}`);
    }
  }

  static debug(msg: string) {
    if (Log.isShowLog()) {
      console.debug(`${LOG_TAG} ${msg}`);
    }
  }

  static log(msg: string) {
    if (Log.isShowLog()) {
      console.log(`${LOG_TAG} ${msg}`);
    }
  }

  static warn(msg: string) {
    if (Log.isShowLog()) {
      console.warn(`${LOG_TAG} ${msg}`);
    }
  }

  static error(msg: string) {
    if (Log.isShowLog()) {
      console.error(`${LOG_TAG} ${msg}`);
    }
  }
}

export function func() {
  return 'har func';
}

export function func2() {
  return 'har func2';
}