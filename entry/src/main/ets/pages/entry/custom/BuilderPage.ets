import { showTextBuilderGlobal } from './Builders';
import { promptAction } from '@kit.ArkUI';

class ParamClass {
  message: string = ''
  other: string = ''
}

class ParamClass2 {
  count: number = -1
}

@Entry
@Component
struct BuilderPage {
  @State message: string = '测试@Builder';
  @State count: number = 100;

  build() {
    Column({ space: 10 }) {
      Text(`message=${this.message}`)
      Text(`count=${this.count}`)
      // this内函数
      this.showTextBuilder()
      // 文件内函数
      showTextBuilderInFile()
      // 全局函数
      showTextBuilderGlobal()
      // 值传递
      this.showTextValueBuilder(this.message, this.count)
      // 引用传递 对象字面量 1个参数 TODO 改变状态 可以刷新
      this.showTextValueBuilderQuote({
        message: this.message,
        other: '' // TODO 所有属性都得赋值 计时该属性有默认值
      })
      // 引用传递 对象字面量 2个参数 TODO 改变状态 不能刷新
      this.showTextValueBuilderQuote2({
        message: this.message,
        other: ''
      }, { count: this.count })
      Button('改变messageA').onClick(() => {
        this.message += 'A'
        this.count += 100
      })
    }
    .height('100%')
    .width('100%')
  }

  // TODO 使用@Builder封装函数 可复用
  @Builder
  showTextBuilder() {
    Text('@Builder this')
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
  }

  // @Builder函数 可以带参数
  @Builder
  showTextValueBuilder(param: string, count: number) {
    Text(`Click ${param}_${count}`)
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        // TODO 禁止@Builder函数内修改参数的值
        param += 'B'
        count += 100
        promptAction.showToast({message: "@Builder内修改参数值B"})
      })
  }

  // @Builder函数 可以带参数
  @Builder
  showTextValueBuilderQuote(param: ParamClass) {
    Text(`Click 1 ${param.message}`)
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        // TODO 禁止@Builder函数内修改参数的值 crash
        // param.message += 'C'
        promptAction.showToast({message: "@Builder内修改参数值C"})
      })
  }

  // @Builder函数 可以带参数
  @Builder
  showTextValueBuilderQuote2(param: ParamClass, param2: ParamClass2) {
    Text(`2 ${param.message}_${param2.count}`)
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
  }
}

@Builder
function showTextBuilderInFile() {
  Text('@Builder in file')
    .fontSize(30)
    .fontWeight(FontWeight.Bold)
}