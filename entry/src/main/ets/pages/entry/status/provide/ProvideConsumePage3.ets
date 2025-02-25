@Component
struct GrandSon {
  // @Consume装饰的变量通过相同的属性名绑定其祖先内的@Provide装饰的变量
  @Consume("reviewVotes") reviewVotes: number;

  build() {
    Column() {
      Text(`GrandSon(${this.reviewVotes})`) // Text显示10
      Button(`reviewVotes(${this.reviewVotes}), give +1`)
        .onClick(() => this.reviewVotes += 1)
    }
    .width('50%')
  }
}

@Component
struct ChildProvideConsume3 {
  @Provide({ allowOverride: "reviewVotes" }) reviewVotes: number = 10;

  build() {
    Row({ space: 5 }) {
      Column() {
        Text(`ChildProvideConsume3(${this.reviewVotes})`) // Text显示10
        GrandSon()
      }
    }
  }
}

@Component
struct ParentProvideConsume3 {
  // TODO 允许子组定义重名@Provder
  @Provide({ allowOverride: "reviewVotes" }) reviewVotes: number = 20;

  build() {
    ChildProvideConsume3()
  }
}

@Entry
@Component
struct ProvideConsumePage3 {
  @Provide("reviewVotes") reviewVotes: number = 40;

  build() {
    Column() {
      Button(`reviewVotes(${this.reviewVotes}), give +1`)
        .onClick(() => this.reviewVotes += 1)
      ParentProvideConsume3()
    }
  }
}