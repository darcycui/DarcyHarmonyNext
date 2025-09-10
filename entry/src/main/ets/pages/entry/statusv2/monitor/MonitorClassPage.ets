import { Log } from "static_library_common";

@Builder
export function NavigationBuilder() {
  MonitorClassPage()
}

@ObservedV2
class MonitorClass {
  @Trace
  name: string
  @Trace
  id: number
  @Trace
  innerClass: MonitorInnerClass

  constructor(name: string, id: number, innerClass: MonitorInnerClass) {
    this.name = name;
    this.id = id;
    this.innerClass = innerClass;
  }
}

@ObservedV2
class MonitorInnerClass {
  @Trace
  innerName: string
  @Trace
  innerId: number

  constructor(innerName: string, innerId: number) {
    this.innerName = innerName;
    this.innerId = innerId;
  }
}

@Entry
@ComponentV2
struct MonitorClassPage {
  monitorClass: MonitorClass = new MonitorClass('Tom', 8, new MonitorInnerClass('Jerry', 4));

  @Monitor('monitorClass.name')
  onNameChanged(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      Log.log(`path=${path}`);
      Log.log(`changed from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`)
    })
  }

  @Monitor('monitorClass.id')
  onIdChanged(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      Log.log(`path=${path}`);
      Log.log(`changed from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`)
    })
  }

  @Monitor('monitorClass.innerClass.innerName')
  onInnerClassChanged(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      Log.log(`path=${path}`);
      Log.log(`changed from ${JSON.stringify(monitor.value(path)?.before)} to ${JSON.stringify(monitor.value(path)?.now)}`)
    })
  }
  build() {
    NavDestination() {
      Column({ space: 5 }) {
        Text('点击按钮后从日志查看Monitor结果')
        Button('修改 name')
          .width('100%').onClick(() => {
            this.monitorClass.name = 'TomTom';
          })
        Button('修改 id')
          .width('100%').onClick(() => {
            this.monitorClass.id = 88;
          })
        Button('修改 inner name')
          .width('100%').onClick(() => {
            this.monitorClass.innerClass.innerName = 'JerryJerry';
          })
        Button('修改 inner id')
          .width('100%').onClick(() => {
            this.monitorClass.innerClass.innerId = 44;
          })
        Button('修改 inner class整体')
          .width('100%').onClick(() => {
            this.monitorClass.innerClass = new MonitorInnerClass('Lucas', 16);
          })
      }
      .height('100%')
      .width('100%')
    }.title('MonitorClass')
  }
}