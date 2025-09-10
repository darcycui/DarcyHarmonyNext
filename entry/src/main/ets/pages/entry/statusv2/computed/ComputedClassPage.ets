import { Log } from "static_library_common";

@Builder
export function NavigationBuilder() {
  ComputedClassPage()
}

@ObservedV2
class ComputedClass {
  @Trace firstName: string
  @Trace lastName: string

  constructor(firstName: string, lastName: string) {
    this.firstName = firstName;
    this.lastName = lastName;
  }

  @Computed
  get fullName() {
    Log.info(`计算 Computed fullName`);
    return this.firstName + ' ' + this.lastName;
  }
}
const constClass = new ComputedClass('Hua', 'Li');

@Entry
@ComponentV2
struct ComputedClassPage {
  // 直接使用 new 创建对象 会重新计算 @computed无效
  // computedClass: ComputedClass = new ComputedClass('Hua', 'Li');
  // darcyRefactor: 这里使用 constClass 不会重新计算
  computedClass: ComputedClass = constClass;

  @Monitor('computedClass.fullName')
  onComputedClassFullNameChanged(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      Log.info(`path: ${path}`);
      Log.log(`computedClass.fullName changed from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`);
    })

  }

  build() {
    NavDestination() {
      Column({ space: 5 }) {
        Text('点击按钮 查看日志').width('100%')
        Text(this.computedClass.firstName)
        Text(this.computedClass.lastName)
        // 多次获取fullName
        Text(this.computedClass.fullName)
        Text(this.computedClass.fullName)
        Text(this.computedClass.fullName)

        Button('修改 FirstName').width('100%').onClick(() => {
          this.computedClass.firstName = 'HuaHua';
        })
        Button('修改 LastName').width('100%').onClick(() => {
          this.computedClass.lastName = 'LiLi';
        })
      }.alignItems(HorizontalAlign.Start)
      .height('100%')
      .width('100%')
    }.title('Computed Class')
  }
}