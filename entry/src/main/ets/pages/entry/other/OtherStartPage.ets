// 入口组件 获取Ability共享的LocalStorage
@Entry({storage: LocalStorage.getShared()})
@Component
struct OtherStartPage {
  @State message: string = 'OtherAbility Start Page';
  @StorageLink('PropA') storageLink: number = -2;
  @StorageLink('PropB') storageLinkObject: DataOtherPage = new DataOtherPage(-200);

  @LocalStorageLink('name1') name1:string = 'name1'
  @LocalStorageLink('id1') id1:number = -1

  build() {
    Row() {
      Column({ space: 10 }) {
        Text(`want param from LocalStorage name=${this.name1}`)
        Text(`want param from LocalStorage id1=${this.id1}`)
        Text(this.message)
          .fontSize($r('app.float.page_text_font_size_normal'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.message = 'Welcome';
          })
        Button(`From AppStorage ${this.storageLink}`)
          .width('100%').onClick(() => {
            this.storageLink += 1;
          })

        Button(`From AppStorage ${this.storageLinkObject.code}`)
          .width('100%').onClick(() => {
            this.storageLinkObject.code += 1;
          })
      }
      .padding({top:20, bottom:20})
      .width('100%')
      .backgroundColor($r('app.color.purple'))
    }
    .height('100%')
    .backgroundColor($r('app.color.green'))
  }
}

class DataOtherPage {
  code: number;

  constructor(code: number) {
    this.code = code;
  }
}