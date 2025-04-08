import { common } from '@kit.AbilityKit';
import { RouterHelper } from 'static_library_common';

@Entry
@Component
struct LoginIndex {
  @State userName: string = '';
  @State password: string = '';
  context = getContext(this) as common.UIAbilityContext;

  build() {
    Column() {
      Text($r('app.string.user_name_tip'))
        .id('UserNameTip')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .align(Alignment.TopStart)
        .textAlign(TextAlign.Start)
      TextInput({ placeholder: $r('app.string.user_name_placeholder'), text: this.userName })
        .id('UserNameInput')
        .type(InputType.Normal)
        .onChange((value: string) => {
          this.userName = value;
        })

      Text($r('app.string.password_tip'))
        .id('PasswordTip')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .align(Alignment.TopStart)
        .textAlign(TextAlign.Start)
      TextInput({ placeholder: $r('app.string.user_name_placeholder'), text: this.password })
        .id('PasswordInput')
        .type(InputType.Password)
        .onChange((value: string) => {
          this.password = value;
        })
      this.startPage();
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  startPage() {
    Button($r("app.string.HomePage"))
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      })
      .margin({ top: 10 })// 外边距
      .onClick((event: ClickEvent) => {
        // TODO entry module页面跳转 使用want
        RouterHelper.startAbility(this.context, "HomeAbility", {})
      })
  }
}