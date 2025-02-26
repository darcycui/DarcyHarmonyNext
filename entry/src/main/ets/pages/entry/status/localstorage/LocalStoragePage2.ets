import { Log } from "static_common";

// 第二个页面组件 获取Ability共享的localStorage
@Entry({storage: LocalStorage.getShared()})
@Component
struct LocalStoragePage2 {
  @State message: string = ''
  onPageShow(): void {
    // 接收传递进来的参数
    const params = this.getUIContext().getRouter().getParams() as Record<string, string>; // 获取传递过来的参数对象
    if (params) {
      this.message = params.message as string ?? 'default'; // 获取message属性的值
    } else {
      Log.error(`router params is null`)
    }
  }
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropA'属性建立双向绑定 TODO 如果没有'PropA',则使用默认值 1
  @LocalStorageLink('PropA') parentLinkNumber: number = 1;
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropB'属性建立双向绑定
  @LocalStorageLink('PropB') parentLinkObject: Data = new Data(0);

  build() {
    Column({ space: 15 }) {
      Text(`title: ${this.message}`)
      Button(`2.Parent from LocalStorage ${this.parentLinkNumber}`)// 由于LocalStorage中PropA已经被初始化，因此this.parentLinkNumber的值为47
        .onClick(() => {
          this.parentLinkNumber += 1;
        })

      Button(`2.Parent from LocalStorage ${this.parentLinkObject.code}`)// 由于LocalStorage中PropB已经被初始化，因此this.parentLinkObject.code的值为50
        .onClick(() => {
          this.parentLinkObject.code += 1;
        })
      // @Component子组件自动获得对Parent LocalStorage实例的访问权限。
      ChildLocal2()
    }
  }
}

@Component
struct ChildLocal2 {
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropA'属性建立双向绑定 TODO 如果没有'PropA',则使用默认值 -1
  @LocalStorageLink('PropA') childLinkNumber: number = -2;
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropB'属性建立双向绑定
  @LocalStorageLink('PropB') childLinkObject: Data = new Data(-2);

  build() {
    Column({ space: 15 }) {
      // 更改将同步至LocalStorage中的'PropA'以及Parent.parentLinkNumber
      Button(`2.Child from LocalStorage ${this.childLinkNumber}`)
        .onClick(() => {
          this.childLinkNumber += 1;
        })

      // 更改将同步至LocalStorage中的'PropB'以及Parent.parentLinkObject.code
      Button(`2.Child from LocalStorage ${this.childLinkObject.code}`)
        .onClick(() => {
          this.childLinkObject.code += 1;
        })
    }
  }
}

export class Data {
  code: number;

  constructor(code: number) {
    this.code = code;
  }
}