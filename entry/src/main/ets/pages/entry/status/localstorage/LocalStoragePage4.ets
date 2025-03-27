
// 组件 获取Ability共享的localStorage
@Entry({ storage: LocalStorage.getShared() })
@Component
struct LocalStoragePage4 {
  // @LocalStorageProp 变量装饰器与LocalStorage中的'PropA'属性建立单向绑定 TODO 如果没有'PropA',则使用默认值 1
  @LocalStorageProp('PropA') parentLinkNumber: number = 1;

  build() {
    Column({ space: 15 }) {
      Button(`Parent from LocalStorage ${this.parentLinkNumber}`)// 由于LocalStorage中PropA已经被初始化，因此this.parentLinkNumber的值为47
        .onClick(() => {
          this.parentLinkNumber += 1;
        })
      // @Component子组件自动获得对Parent LocalStorage实例的访问权限。
      ChildLocal4()
    }
  }
}

@Component
struct ChildLocal4 {
  // @LocalStorageProp 变量装饰器与LocalStorage中的'PropA'属性建立单向绑定 TODO 如果没有'PropA',则使用默认值 -1
  @LocalStorageProp('PropA') childLinkNumber: number = -1;

  build() {
    Column({ space: 15 }) {
      // 更改将同步至LocalStorage中的'PropA'以及Parent.parentLinkNumber
      Button(`Child from LocalStorage ${this.childLinkNumber}`)
        .onClick(() => {
          this.childLinkNumber += 1;
        })
    }
  }
}

export class DataStorage4 {
  code: number;

  constructor(code: number) {
    this.code = code;
  }
}