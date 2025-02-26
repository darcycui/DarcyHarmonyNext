import { startPage } from "../../../../utils/RouterHelper";
import { PAGE_LOCAL_STORAGE_PAGE_2 } from "../../../PageName";

// 第一个页面组件 获取Ability共享的localStorage
@Entry({ storage: LocalStorage.getShared() })
@Component
struct LocalStoragePage1 {
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropA'属性建立双向绑定 TODO 如果没有'PropA',则使用默认值 1
  // @LocalStorageLink('PropA') parentLinkNumber: number = 1;
  @LocalStorageProp('PropA') parentLinkNumber: number = 1;
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropB'属性建立双向绑定
  @LocalStorageLink('PropB') parentLinkObject: Data = new Data(0);

  build() {
    Column({ space: 15 }) {
      Button(`Parent from LocalStorage ${this.parentLinkNumber}`)// 由于LocalStorage中PropA已经被初始化，因此this.parentLinkNumber的值为47
        .onClick(() => {
          this.parentLinkNumber += 1;
        })

      Button(`Parent from LocalStorage ${this.parentLinkObject.code}`)// 由于LocalStorage中PropB已经被初始化，因此this.parentLinkObject.code的值为50
        .onClick(() => {
          this.parentLinkObject.code += 1;
        })
      // @Component子组件自动获得对Parent LocalStorage实例的访问权限。
      ChildLocal1()
      Button('跳转页面2').onClick(() => {
        startPage(PAGE_LOCAL_STORAGE_PAGE_2, { 'message': '测试不同页面共享LocalStorage' })
      })
    }
  }
}

@Component
struct ChildLocal1 {
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropA'属性建立双向绑定 TODO 如果没有'PropA',则使用默认值 -1
  // @LocalStorageLink('PropA') childLinkNumber: number = -1;
  @LocalStorageProp('PropA') childLinkNumber: number = -1;
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropB'属性建立双向绑定
  @LocalStorageLink('PropB') childLinkObject: Data = new Data(0);

  build() {
    Column({ space: 15 }) {
      // 更改将同步至LocalStorage中的'PropA'以及Parent.parentLinkNumber
      Button(`Child from LocalStorage ${this.childLinkNumber}`)
        .onClick(() => {
          this.childLinkNumber += 1;
        })

      // 更改将同步至LocalStorage中的'PropB'以及Parent.parentLinkObject.code
      Button(`Child from LocalStorage ${this.childLinkObject.code}`)
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