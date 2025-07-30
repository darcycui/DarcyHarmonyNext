import { ChatItem } from '../../../models/ChatItem';
import { ChatItemComponent } from '../../../views/ChatItemComponent';

@Entry
@Component
struct ChatPage {
  @State message: string = '消息';
  private chatList: Array<ChatItem> = [
    new ChatItem(200, 'Jerry', '你好 我是一只小老鼠'),
    new ChatItem(101, 'Tom', '你好 我是一只老猫'),
  ]

  build() {
    Column() {
      Stack() {
        Text(this.message)
          .fontSize(20)
          .fontColor(Color.Black)
        Row() {
          Image($r('app.media.aaa')).width(34).height(34).margin({ left: 16 })
            .onClick(() => {
              // 返回
            })
        }.width('100%')
      }.width('100%').height(60).backgroundColor(Color.Blue)

      List() {
        ForEach(this.chatList, (item: ChatItem, index: number) => {
          ListItem() {
            ChatItemComponent({ model: item })
          }.width('100%')
        }, (item: ChatItem, index: number) => {
          return JSON.stringify(item)
        })
      }.width('100%').height('auto').layoutWeight(1)

      Row() {
        TextInput().layoutWeight(1)
        Text('发送').fontSize(20).fontColor(Color.Black).margin({ right: 16 })
      }.width('100%').height(50).backgroundColor(Color.Blue)
    }
    .height('100%')
    .width('100%')
  }
}