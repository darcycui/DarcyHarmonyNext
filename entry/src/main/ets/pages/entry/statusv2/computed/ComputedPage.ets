import { Log } from "static_library_common";

@Builder
export function NavigationBuilder() {
  ComputedPage()
}

@Entry
@ComponentV2
struct ComputedPage {
  @Local firstName: string = 'Hua'
  @Local lastName: string = 'Li'
  age: number = 18
  // @Computed计算次数
  @Local computedCount: number = 0;

  // 计算属性 只计算1次 本质是 getter 访问器
  @Computed
  get fullName() {
    Log.info(`计算 Computed fullName`);
    this.computedCount++;
    return this.firstName + ' ' + this.lastName + ' 年龄 ' + this.age;
  }

  // 可以被 Monitor 监听
  @Monitor('fullName')
  onFullNameChanged(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      Log.info(`Monitor fullName path: ${path}`);
      Log.log(`fullName changed from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`)
    })
  }

  build() {
    NavDestination() {
      Column({ space: 5 }) {
        Text(this.firstName)
        Text(this.lastName)
        Text(`年龄 ${this.age}`)
        Text(`${this.fullName}`) // 获取一次fullName
        Text(`${this.fullName}`) // 再获取一次fullName，累计获取两次fullName，但是fullName不会重新计算

        Text(`fullName 计算次数: ${this.computedCount}`)
        Button('修改 FirstName').width('100%').onClick(() => {
          this.firstName = 'HuaHua';
        })
        Button('修改 LastName').width('100%').onClick(() => {
          this.lastName = 'LiLi';
        })
        Button('修改 Age').width('100%').onClick(() => {
          this.age++
          Log.info(`修改 Age: ${this.age}`);
        })
      }.width('100%').height('100%')
      .alignItems(HorizontalAlign.Start)
    }.title('Computed')
  }
}