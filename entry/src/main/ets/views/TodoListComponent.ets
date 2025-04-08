import { Log } from 'static_library_common';
import ThingsViewModel from "../viewmodel/ThingViewModel";
import { ThingsViewModelArray } from "../viewmodel/TodoListViewModel";
import { ThingComponent } from "./ThingComponent";

@Component
export struct TodoListComponent {
  // 使用 @ObjectLink注解 观察嵌套属性的赋值
  @ObjectLink thingsViewModelArray: ThingsViewModelArray;

  build() {
    Column() {
      List() {
        ForEach(this.thingsViewModelArray,
          (item: ThingsViewModel) => {
            ListItem() {
              // 待办事项
              // TODO 注意这里 不能使用getItem(item)函数返回值传递给子组件@ObjLinked变量
              // ThingsComponent({ things: getItem(item) }).margin(5)
              ThingComponent({ thingViewModel: item }).margin(5)
            }
          },
          (item: ThingsViewModel) => {
            return item.thingsName;
          })
      }.width('100%').height('100%')
    }
  }
}

function getItem(item: ThingsViewModel): ThingsViewModel {
  Log.log(`getItem: ${item.thingsName}`)
  return item;
}
