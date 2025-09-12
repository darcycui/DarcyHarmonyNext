@Entry
@Component
struct PreviewPage {
  @State message: string = '预览页面'

  build() {
    Column({ space: 10 }) {
      Text('预览页面')
      Text(this.message)
      Text(this.message)
    }
  }
}