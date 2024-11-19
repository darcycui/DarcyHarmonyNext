// library/src/main/ts/test.ets
export class Log {
  private static showLog: boolean = false;

  static setShowLog(showLog: boolean) {
    Log.showLog = showLog;
  }

  static isShowLog(): boolean {
    return Log.showLog
  }

  static info(msg: string) {
    if (Log.isShowLog()) {
      console.info(msg);
    }
  }

  static debug(msg: string) {
    if (Log.isShowLog()) {
      console.debug(msg);
    }
  }

  static log(msg: string) {
    if (Log.isShowLog()) {
      console.log(msg);
    }
  }

  static warn(msg: string) {
    if (Log.isShowLog()) {
      console.warn(msg);
    }
  }

  static error(msg: string) {
    if (Log.isShowLog()) {
      console.error(msg);
    }
  }
}

export function func() {
  return 'har func';
}

export function func2() {
  return 'har func2';
}