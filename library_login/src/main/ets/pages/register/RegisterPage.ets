/**
 * RegisterPage - V2 版注册页面
 *
 * 使用 @ComponentV2 + @Local 配合 RegisterViewModelV2（@ObservedV2）
 * 展示 V2 状态管理的标准用法：
 *   - 加载中 → LoadingProgress
 *   - 注册完成 → 显示成功信息
 *   - 注册失败 → 显示错误信息
 *
 * ─── MVI 架构流向 ─────────────────────────────────────
 *   @ComponentV2 View → dispatch(intent) → @ObservedV2 ViewModel → UseCase → Repository
 *   View 层不直接调用 ViewModel 方法，统一通过 dispatch 发送 Intent
 */
import { common } from '@kit.AbilityKit';
import { RouterHelper } from 'static_library_common';

import RegisterViewModelV2 from './viewmodel/RegisterViewModelV2';
import {
  DoRegisterIntent,
  UpdateRegisterUserNameIntent,
  UpdateRegisterPasswordIntent,
  UpdatePhoneIntent,
  UpdateNicknameIntent,
  UpdateEmailIntent
} from './intent/RegisterIntent';

@Entry
@ComponentV2
struct RegisterPage {
  /**
   * @Local 持有 ViewModel（V2 版 @State）
   * ViewModel 内部使用 @ObservedV2 + @Trace 实现细粒度响应式
   */
  @Local viewModel: RegisterViewModelV2 = new RegisterViewModelV2();

  /**
   * 获取 UIAbilityContext
   */
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  /**
   * 页面初始化生命周期
   */
  aboutToAppear(): void {
  }

  build() {
    Column() {
      // ── 注册标题 ──
      Text($r('app.string.register_title'))
        .id('RegisterTitle')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .align(Alignment.TopStart)
        .textAlign(TextAlign.Start)
        .margin({ bottom: 16 })

      // ── 用户名提示 ──
      Text($r('app.string.register_username_tip'))
        .id('RegisterUserNameTip')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .align(Alignment.TopStart)
        .textAlign(TextAlign.Start)

      // ── 用户名输入框 ──
      TextInput({
        placeholder: $r('app.string.register_username_placeholder'),
        text: this.viewModel.state.userName || '王老吉'
      })
        .id('RegisterUserNameInput')
        .type(InputType.Normal)
        .onChange((value: string) => {
          this.viewModel.dispatch(new UpdateRegisterUserNameIntent(value));
        })

      // ── 密码提示 ──
      Text($r('app.string.register_password_tip'))
        .id('RegisterPasswordTip')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .align(Alignment.TopStart)
        .textAlign(TextAlign.Start)

      // ── 密码输入框 ──
      TextInput({
        placeholder: $r('app.string.register_password_placeholder'),
        text: this.viewModel.state.password || '123456'
      })
        .id('RegisterPasswordInput')
        .type(InputType.Password)
        .onChange((value: string) => {
          this.viewModel.dispatch(new UpdateRegisterPasswordIntent(value));
        })

      // ── 手机号提示 ──
      Text($r('app.string.register_phone_tip'))
        .id('RegisterPhoneTip')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .align(Alignment.TopStart)
        .textAlign(TextAlign.Start)

      // ── 手机号输入框 ──
      TextInput({
        placeholder: $r('app.string.register_phone_placeholder'),
        text: this.viewModel.state.phone || '13800138000'
      })
        .id('RegisterPhoneInput')
        .type(InputType.Normal)
        .onChange((value: string) => {
          this.viewModel.dispatch(new UpdatePhoneIntent(value));
        })

      // ── 昵称提示 ──
      Text($r('app.string.register_nickname_tip'))
        .id('RegisterNicknameTip')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .align(Alignment.TopStart)
        .textAlign(TextAlign.Start)

      // ── 昵称输入框 ──
      TextInput({
        placeholder: $r('app.string.register_nickname_placeholder'),
        text: this.viewModel.state.nickname || 'WangLaoJi'
      })
        .id('RegisterNicknameInput')
        .type(InputType.Normal)
        .onChange((value: string) => {
          this.viewModel.dispatch(new UpdateNicknameIntent(value));
        })

      // ── 邮箱提示 ──
      Text($r('app.string.register_email_tip'))
        .id('RegisterEmailTip')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .align(Alignment.TopStart)
        .textAlign(TextAlign.Start)

      // ── 邮箱输入框 ──
      TextInput({
        placeholder: $r('app.string.register_email_placeholder'),
        text: this.viewModel.state.email || 'zhangsan@example.com'
      })
        .id('RegisterEmailInput')
        .type(InputType.Normal)
        .onChange((value: string) => {
          this.viewModel.dispatch(new UpdateEmailIntent(value));
        })

      // ── 注册按钮 ──
      Button($r("app.string.register"))
        .width('100%')
        .margin({ top: 10 })
        .onClick(async () => {
          // 通过 dispatch 发送注册 Intent（MVI 统一入口）
          await this.viewModel.dispatch(new DoRegisterIntent());
        })

      // ── 加载中：显示 LoadingProgress ──
      if (this.viewModel.isLoading) {
        LoadingProgress()
          .width(50)
          .height(50)
          .layoutWeight(1)
      }

      Blank().height(16).width('100%')

      // ── 注册失败：显示错误信息 ──
      if (this.viewModel.errorMessage) {
        Text(this.viewModel.errorMessage)
          .id('RegisterErrorText')
          .fontSize(14)
          .fontColor(Color.Red)
          .width('100%')
          .align(Alignment.TopStart)
          .textAlign(TextAlign.Start)
      }

      // ── 注册成功：显示成功信息 ──
      if (this.viewModel.isLoaded && !this.viewModel.errorMessage) {
        Text($r('app.string.register_success'))
          .id('RegisterSuccessText')
          .fontSize(14)
          .fontColor(Color.Green)
          .width('100%')
          .align(Alignment.TopStart)
          .textAlign(TextAlign.Start)
      }
    }
    .height('100%')
    .width('100%')
    .padding(16)
  }
}
