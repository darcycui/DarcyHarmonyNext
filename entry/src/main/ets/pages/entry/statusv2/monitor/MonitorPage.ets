import { Log } from "static_library_common";
import { LocalBean } from "../local/LocalPage";

@Builder
export function NavigationBuilder() {
  MonitorPage()
}

@Entry
@ComponentV2
struct MonitorPage {
  @Local count: number = 1
  @Local message: string = 'Local状态变量';
  @Local flag: boolean = false
  // 只能观察到重新赋值 不能观察到类属性的修改
  @Local localBean: LocalBean = new LocalBean('Tom', 8)

  name:string = 'MonitorPage';

  @Monitor('count')
  onCountChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      Log.log(`path=${path}`)
      Log.log(`changed from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`)
    })
  }

  @Monitor('name')
  onNameChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      Log.log(`path=${path}`)
      Log.log(`changed from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`)
    })
  }

  @Monitor('message')
  onMessageChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      Log.log(`path=${path}`)
      Log.log(`changed from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`)
    })
  }

  @Monitor('flag')
  onFlagChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      Log.log(`path=${path}`)
      Log.log(`changed from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`)
    })
  }

  @Monitor('localBean')
  onLocalBeanChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      Log.log(`path=${path}`)
      Log.log(`changed from ${JSON.stringify(monitor.value(path)?.before)} to ${JSON.stringify(monitor.value(path)?.now)}`)
    })
  }

  build() {
    NavDestination() {
      Column({ space: 10 }) {
        Text(`count=${this.count}`)
        Text(`flag=${this.flag}`)
        Text(this.message)
        Text(JSON.stringify(this.localBean))
        Button('修改 count').width('100%').onClick(() => {
          this.count++
        })
        Button('修改 flag').width('100%').onClick(() => {
          this.flag = !this.flag
        })
        Button('修改 message').width('100%').onClick(() => {
          this.message += ' 已改变'
        })
        Button('修改 localBean').width('100%').onClick(() => {
          this.localBean.id++
        })
        Button('重新赋值 localBean').width('100%').onClick(() => {
          this.localBean = new LocalBean('Jerry', 4)
        })
        Button('修改 name').width('100%').onClick(() => {
          this.name += ' 已修改'
          Log.log(`name=${this.name}`)
        })
      }
      .height('100%')
      .width('100%')
    }.title('Monitor')
  }
}