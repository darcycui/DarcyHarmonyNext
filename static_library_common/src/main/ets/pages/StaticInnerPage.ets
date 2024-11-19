/**
 * 警告:
 * It's not a recommended way to export struct with @Entry decorator,
 * which may cause ACE Engine error in component preview mode.
 */
@Entry({ routeName: "pages/static/common/StaticInnerPage" })
@Component
export struct StaticInnerPage {
  build() {
    Column() {
      Text("StaticInnerPage")
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
    }
    .width("100%")
    .height("100%")
  }
}