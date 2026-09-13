/**
 * LoginIndex - V2 版登录页面
 *
 * 使用 @ComponentV2 + @Local 配合 LoginViewModelV2（@ObservedV2）
 * 展示 V2 状态管理的标准用法：
 *   - 加载中 → LoadingProgress
 *   - 登录完成 → 跳转主页
 *   - 登录失败 → 显示错误信息
 *
 * ─── MVI 架构流向 ─────────────────────────────────────
 * @ComponentV2 View → dispatch(intent) → @ObservedV2 ViewModel → UseCase → Repository
 *   View 层不直接调用 ViewModel 方法，统一通过 dispatch 发送 Intent
 */
import { common } from '@kit.AbilityKit';
import { AbilityHelper, NavigationHelper, RouterHelper, ScreenPhase } from 'static_library_common';
import { LoginViewModelV2, DoLoginIntent, UpdateUserNameIntent, UpdatePasswordIntent } from 'library_login';

@Builder
export function NavigationBuilder() {
  LoginIndex()
}


@Entry
@ComponentV2
struct LoginIndex {
  /**
   * @Local 持有 ViewModel（V2 版 @State）
   * ViewModel 内部使用 @ObservedV2 + @Trace 实现细粒度响应式
   */
  @Local viewModel: LoginViewModelV2 = new LoginViewModelV2();
  /**
   * 获取 UIAbilityContext，供 ViewModel 登录使用
   */
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  /**
   * navigation 控制器
   */
  pathStack: NavPathStack = new NavPathStack();

  /**
   * 页面初始化生命周期
   */
  aboutToAppear(): void {
  }

  build() {
    NavDestination() {
      Column() {
        // ── 登录标题 ──
        Text($r('app.string.login_title'))
          .id('LoginTitle')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .align(Alignment.TopStart)
          .textAlign(TextAlign.Start)
          .margin({ bottom: 16 })

        // ── 用户名提示 ──
        Text($r('app.string.user_name_tip'))
          .id('UserNameTip')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .align(Alignment.TopStart)
          .textAlign(TextAlign.Start)

        // ── 用户名输入框 ──
        TextInput({
          placeholder: $r('app.string.user_name_placeholder'),
          text: this.viewModel.state.userName || "王老吉"
        })
          .id('UserNameInput')
          .type(InputType.Normal)
          .onChange((value: string) => {
            this.viewModel.dispatch(new UpdateUserNameIntent(value));
          })

        // ── 密码提示 ──
        Text($r('app.string.password_tip'))
          .id('PasswordTip')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .align(Alignment.TopStart)
          .textAlign(TextAlign.Start)

        // ── 密码输入框 ──
        TextInput({
          placeholder: $r('app.string.user_name_placeholder'),
          text: this.viewModel.state.password || "123456"
        })
          .id('PasswordInput')
          .type(InputType.Password)
          .onChange((value: string) => {
            this.viewModel.dispatch(new UpdatePasswordIntent(value));
          })

        // ── 登录按钮 ──
        Button($r("app.string.Login"))
          .width('100%')
          .margin({ top: 10 })
          .onClick(async () => {
            // 通过 dispatch 发送登录 Intent（MVI 统一入口）
            await this.viewModel.dispatch(new DoLoginIntent());

            // 登录成功后跳转主页
            if (this.viewModel.state.screenState.is(ScreenPhase.SUCCESS)) {
              AbilityHelper.startAbility(this.context, "EntryAbility", {}, 'entry');
              setTimeout(() => {
                this.context.terminateSelf();
              }, 200);
            }
          })

        // ── 注册按钮：跳转到注册页面 ──
        Button($r("app.string.register"))
          .width('100%')
          .margin({ top: 10 })
          .onClick(() => {
            NavigationHelper.startPage(this.pathStack, 'pages/register/RegisterPage');
          })

        // ── 加载中：显示 LoadingProgress ──
        if (this.viewModel.state.screenState.isLoadingPhase) {
          LoadingProgress()
            .width(50)
            .height(50)
            .layoutWeight(1)
        }

        // ── 登录失败：显示错误信息 ──
        if (this.viewModel.state.screenState.errorMessage) {
          Text(this.viewModel.state.screenState.errorMessage)
            .fontColor(Color.Red)
            .fontSize(16)
            .margin({ top: 10, bottom: 10 })
        }
      }
      .height('100%')
      .width('100%')
      .padding(16)
    }
  }
}
