import { ChatItem } from "../models/ChatItem"

@Component
export struct ChatItemComponent {
  @Prop model: ChatItem;

  build() {
    Column() {
      Text(this.model.time).fontSize(13).fontColor(Color.Gray).width('100%').textAlign(TextAlign.Center)
      if (this.model.isSelf()) {
        this.SelfItem()
      } else {
        this.OtherItem()
      }
    }.width('100%')
    .height('auto')
  }

  @Builder
  OtherItem() {
    Row({ space: 8 }) {
      Image($r('app.media.startIcon')).width(34).height(34).borderRadius(17).backgroundColor(Color.Gray)
      Column({ space: 5 }) {
        Text(this.model.from).fontSize(14).fontColor($r('app.color.message_color'))
        Text(this.model.message)
          .fontSize(15)
          .fontColor(Color.Black)
          .backgroundColor($r('app.color.message_bg_color_self'))
          .padding(8)
          .borderRadius(6)
          .constraintSize({ minWidth: 20, maxWidth: 260 })
      }.alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .height('auto')
    }
    .alignItems(VerticalAlign.Top)
    .width('100%')
    .height('auto')
    .margin({
      left: 10,
      top: 10,
      right: 0,
      bottom: 0
    })
  }

  @Builder
  SelfItem() {
    Row({ space: 8 }) {
      Column({ space: 5 }) {
        Text(this.model.from).fontSize(14).fontColor($r('app.color.message_color'))
        Text(this.model.message)
          .fontSize(15)
          .fontColor(Color.Black)
          .backgroundColor($r('app.color.message_bg_color_other'))
          .padding(8)
          .borderRadius(6)
          .constraintSize({ minWidth: 20, maxWidth: 260 })
      }.alignItems(HorizontalAlign.End)
      .layoutWeight(1)
      .height('auto')

      Image($r('app.media.startIcon')).width(34).height(34).borderRadius(17).backgroundColor(Color.Gray)
    }.alignItems(VerticalAlign.Top)
    .width('100%')
    .height('auto')
    .margin({
      left: 0,
      top: 10,
      right: 10,
      bottom: 0
    })
  }
}