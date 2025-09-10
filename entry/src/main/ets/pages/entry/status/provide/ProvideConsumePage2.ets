@Component
struct ToDoItem {
  // @Consume装饰的变量通过相同的属性名绑定其祖先组件ToDo内的@Provide装饰的变量
  @Consume count: number;

  build() {
    Column() {
      Text(`count(${this.count})`)
      Button(`count(${this.count}), count + 1`)
        .width('100%').onClick(() => this.count += 1)
    }
    .width('50%')
  }
}

@Component
struct ToDoList {
  build() {
    Row({ space: 5 }) {
      ToDoItem()
      ToDoItem()
    }
  }
}

@Component
struct ToDoDemo {
  build() {
    ToDoList()
  }
}

@Entry
@Component
struct ProvideConsumePage2 {
  // @Provide装饰的变量index由入口组件ToDo提供其后代组件
  @Provide count: number = 0;

  build() {
    Column() {
      Button(`count(${this.count}), count + 1`)
        .width('100%').onClick(() => this.count += 1)
      ToDoDemo()
    }
  }
}