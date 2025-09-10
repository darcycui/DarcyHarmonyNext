import { router } from '@kit.ArkUI';

@Entry
@Component({ freezeWhenInactive: true })
struct Page2 {
  @StorageLink('PropA') @Watch("second") storageLink2: number = 1;

  second() {
    console.info("second page: " + `${this.storageLink2}`)
  }

  build() {
    Column({ space: 20 }) {
      Text(`second Page ${this.storageLink2}`)
      Button('Go Back').width('100%')
        .onClick(() => {
          router.back()
        })

      Button('second page storageLink2 + 2').width('100%')
        .onClick(() => {
          this.storageLink2 += 2
        })

    }
  }
}