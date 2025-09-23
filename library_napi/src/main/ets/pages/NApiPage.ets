import { NodeContent } from "@kit.ArkUI";
import nativeNode from 'liblibrary_napi.so';

@Entry({ routeName: 'NApiPage' })
@Component
struct NApiPage {
  @State message: string = 'NApi 绘制UI';
  @State @Watch('changeNativeFlag') showNative: boolean = false;
  // 初始化NodeContent对象。
  private rootSlot = new NodeContent();

  changeNativeFlag(): void {
    if (this.showNative) {
      // 传递NodeContent对象用于Native创建组件的挂载显示
      nativeNode.createNativeRoot(this.rootSlot)
    } else {
      // 销毁NativeModule组件
      nativeNode.destroyNativeRoot()
    }
  }

  build() {
    Column({ space: 10 }) {
      Text(this.message)
      Button(this.showNative ? "NativeUI已显示 点击隐藏" : "NativeUI已隐藏 点击显示").onClick(() => {
        this.showNative = !this.showNative
      })
      Row() {
        // 将NodeContent和ContentSlot占位组件绑定
        ContentSlot(this.rootSlot)
      }.layoutWeight(1).width('100%')
    }
    .width('100%')
    .height('100%')
  }
}

export { NApiPage}; // 添加这行导出语句
