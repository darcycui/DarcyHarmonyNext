import ThingsViewModel from "./ThingViewModel";
import { common } from "@kit.AbilityKit";
import TodoListEntity from "../../../models/TodoListEntity";

// 自定义类型 添加 @Observed注解
@Observed
export class ThingsViewModelArray extends Array<ThingsViewModel> {
}

// TODO ViewModel 添加@Observed注解
@Observed
export default class TodoListViewModel {
  // ViewModel的字段 添加@Track注解
  @Track isChoosen: boolean = true;
  @Track things: ThingsViewModelArray = new ThingsViewModelArray();

  async loadTasks(context: common.UIAbilityContext) {
    let todoListModel = new TodoListEntity([]);
    await todoListModel.loadTasks(context);
    for(let things of todoListModel.things) {
      let thingsViewModel = new ThingsViewModel();
      thingsViewModel.initViewModel(things);
      this.things.push(thingsViewModel);
    }
  }

  chooseAll(): void {
    for(let item of this.things) {
      item.isFinish = this.isChoosen;
    }
    this.isChoosen = !this.isChoosen;
  }
}