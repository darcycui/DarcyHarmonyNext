import { common } from '@kit.AbilityKit';

import TodoListViewModel from './viewmodel/TodoListViewModel';
import { AllChooseComponent } from './views/AllChooseComponent';
import { TodoComponent } from './views/TodoComponent';
import { TodoListComponent } from './views/TodoListComponent';

@Entry
@Component
struct TodoList {
  // 在列表页面 观察列表页对应的ViewModel
  @State viewModel: TodoListViewModel = new TodoListViewModel();
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  // 在aboutToAppear()中 加载数据
  async aboutToAppear() {
    await this.viewModel.loadTasks(this.context);
  }

  build() {
    Column() {
      Row({ space: 40 }) {
        // 全部待办子组件
        TodoComponent()
        // 全选子组件
        AllChooseComponent({ thingsViewModel: this.viewModel })
      }

      Column() {
        // 待办事项列表子组件
        TodoListComponent({ thingsViewModelArray: this.viewModel.things })
      }
    }
    .height('100%')
    .width('100%')
    .margin({ top: 5, bottom: 5 })
    .backgroundColor('#90f1f3f5')
  }
}