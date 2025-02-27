// 将设备languageCode存入AppStorage中
Environment.envProp('colorMode', ColorMode.LIGHT);
Environment.envProp('accessibilityEnabled', false);
Environment.envProp('fontScale', 1.0);
Environment.envProp('fontWeightScale', 1.0);
Environment.envProp('layoutDirection', LayoutDirection.LTR);
Environment.envProp('languageCode', 'en');

@Entry
@Component
struct EnvironmentPage {
  @StorageProp('colorMode') colorMode: number = ColorMode.LIGHT;
  @StorageProp('accessibilityEnabled') accessibilityEnabled: boolean = false;
  @StorageProp('fontScale') fontScale: number = 1.0;
  @StorageProp('fontWeightScale') fontWeightScale: number = 1.0;
  @StorageProp('layoutDirection') layoutDirection: LayoutDirection = LayoutDirection.LTR;
  @StorageProp('languageCode') languageCode: string = 'en';


  build() {
    Row() {
      Column({ space: 10 }) {
        Text(`colorMode: ${this.colorMode}`)
        Text(`accessibilityEnabled: ${this.accessibilityEnabled}`)
        Text(`fontScale: ${this.fontScale}`)
        Text(`fontWeightScale: ${this.fontWeightScale}`)
        Text(`layoutDirection: ${this.layoutDirection}`)
        // 输出当前设备的languageCode
        Text(`languageCode:${this.languageCode}`)
      }
    }
  }
}