let LOG_TAG = "DarcyLog";

export class Log {
  // private static showLog: boolean = false;
  private static showLog: boolean = true;

  static maxLogLength: number = 4000;

  static setShowLog(showLog: boolean) {
    Log.showLog = showLog;
  }

  static isShowLog(): boolean {
    return Log.showLog
  }

  static info(msg: string) {
    if (Log.isShowLog()) {
      let remaining = msg;
      while (remaining.length > 0) {
        const chunk = remaining.substring(0, Log.maxLogLength);
        console.info(`${LOG_TAG} ${chunk}`);
        remaining = remaining.substring(Log.maxLogLength);
      }
    }
  }

  static debug(msg: string) {
    if (Log.isShowLog()) {
      let remaining = msg;
      while (remaining.length > 0) {
        const chunk = remaining.substring(0, Log.maxLogLength);
        console.debug(`${LOG_TAG} ${chunk}`);
        remaining = remaining.substring(Log.maxLogLength);
      }
    }
  }

  static log(msg: string) {
    if (Log.isShowLog()) {
      let remaining = msg;
      while (remaining.length > 0) {
        const chunk = remaining.substring(0, Log.maxLogLength);
        console.log(`${LOG_TAG} ${chunk}`);
        remaining = remaining.substring(Log.maxLogLength);
      }
    }
  }

  static warn(msg: string) {
    if (Log.isShowLog()) {
      let remaining = msg;
      while (remaining.length > 0) {
        const chunk = remaining.substring(0, Log.maxLogLength);
        console.warn(`${LOG_TAG} ${chunk}`);
        remaining = remaining.substring(Log.maxLogLength);
      }
    }
  }

  static error(msg: string) {
    if (Log.isShowLog()) {
      let remaining = msg;
      while (remaining.length > 0) {
        const chunk = remaining.substring(0, Log.maxLogLength);
        console.error(`${LOG_TAG} ${chunk}`);
        remaining = remaining.substring(Log.maxLogLength);
      }
    }
  }
}