import TodoListViewModel from "../viewmodel/TodoListViewModel";

@Component
export struct AllChooseComponent {
  @State titleName: string = '全选';
  @Link thingsViewModel: TodoListViewModel;

  build() {
    Row() {
      Button(`${this.titleName}`, { type: ButtonType.Capsule })
        .onClick(() => {
          this.thingsViewModel.chooseAll();
          this.titleName = this.thingsViewModel.isChoosen ? '全选' : '取消全选';
        })
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#f7f6cc74')
    }
    .padding({ left: this.thingsViewModel.isChoosen ? 15 : 0 })
    .width('100%')
    .margin({ top: 10, bottom: 10 })
  }
}