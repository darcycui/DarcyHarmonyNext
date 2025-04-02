import ThingsModel from "../models/ThingsModel";

// TODO ViewModel 添加@Observed注解
@Observed
export default class ThingsViewModel {
  // ViewModel的字段 添加@Track注解
  @Track thingsName: string = 'Todo';
  @Track isFinish: boolean = false;

  initViewModel(things: ThingsModel) {
    this.thingsName = things.thingsName;
    this.isFinish = things.isFinish;
  }

  updateIsFinish(): void {
    this.isFinish = !this.isFinish;
  }

  addNameSuffixes(): void {
    this.thingsName += '啦';
  }
}