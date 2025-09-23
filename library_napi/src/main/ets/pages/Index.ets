import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'liblibrary_napi.so';

const DOMAIN = 0x0000;

@Entry({routeName: 'Index'})
@Component
struct Index {
  @State message: string = 'NApi 绘制UI';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.message = 'Welcome';
            hilog.info(DOMAIN, 'testTag', 'Test NAPI 2 + 3 = %{public}d', testNapi.add(2, 3));
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
export { Index }; // 添加这行导出语句
