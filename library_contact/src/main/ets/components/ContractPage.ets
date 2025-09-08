import { JSON } from "@kit.ArkTS"
import { ToastHelper } from "static_library_common"

@Component
export struct ContractPage {
  @State contractList: Array<string> = [
    'Tom',
    'Jerry',
    'Mike',
    'Lucy',
    'Lily',
    'Lucas',
    'Lucifer',
    'Tom',
    'Jerry',
    'Mike',
    'Lucy',
    'Lily',
    'Lucas',
    'Lucifer',
  ]

  build() {
    List() {
      ForEach(this.contractList, (item: string, index: number) => {
        // 必须使用ListItem包裹，否则会报错
        ListItem() {
          Column() {
            Text(item)
              .fontSize(20)
              .fontColor(Color.Black)
              .textAlign(TextAlign.Center)
              .margin({ left: 16 })
              .width('100%')
              .height(60)
              .clickEffect({ level: ClickEffectLevel.LIGHT })
          }
        }.onClick((event: ClickEvent) => {
          ToastHelper.showToast(`index:${index} ${item}`)
        })
      }, (item: string, index: number) => index + JSON.stringify(item))

    }.width('100%')
    .height('100%')
    // 添加分割线
    .divider({
      color: Color.Gray,
      strokeWidth: 1,
      startMargin: 0,
      endMargin: 0
    })
    .scrollBar(BarState.On)
  }
}
