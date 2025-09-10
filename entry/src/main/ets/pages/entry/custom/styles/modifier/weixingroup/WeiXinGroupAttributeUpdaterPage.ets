import { TextData } from './data/TextData';
import { WeiXinGroupTextAttributeUpdater } from './modifier_updater/WeiXinGroupAttributeUpdater';
/**
 * entry/src/main/ets/pages/entry/custom/styles/modifier/weixingroup/WeiXinGroupAttributeUpdaterPage.ets
 * 参考链接：https://mp.weixin.qq.com/s/vdH7hbznyJSluwwa0sLIHQ
 * 实现思路：第三版：基于自定义状态管理的性能优化
 * 系统的动态代理有性能问题 需要优化
 * 1.通过Updater获取到Attribute的实例instance
 * 2.将instance实例传递给Data类
 * 3.Data类代理instance 修改Data的值同时 instance实例也会修改(触发UI刷新)
 *
 * 4.客户端：使用@Watch 监听Data类的属性变化 在回调函数中更新UI
 * 5.客户端：在aboutToAppear() aboutToReuse()中绑定Updater和Data
 * // darcyRefactor: 这里有坑
 * 6.注意：目前状态管理要求组件和Data一一对应 否则状态错乱
 */
@Entry
@Component
struct WeiXinGroupAttributeUpdaterPage {
  @Provide textData: TextData = new TextData(Color.Red)

  build() {
    Column() {
      WeiXinComponent()
    }
    .width('100%')
    .height('100%')
  }
}

@Component
struct WeiXinComponent {
  @State message: string = 'WeiXinGroup 自定义状态管理';
  // darcyRefactor: 这里的TextData不再需要使用 @Observed观察
  @Consume @Watch('updateData') textData: TextData;
  textModifierUpdater: WeiXinGroupTextAttributeUpdater = new WeiXinGroupTextAttributeUpdater();

  aboutToAppear(): void {
    this.updateData();
  }

  private updateData() {
    this.textModifierUpdater.updateData(this.textData);
  }

  aboutToReuse(): void {
    this.textModifierUpdater.updateData(this.textData)
  }

  build() {
    Column({ space: 20 }) {
      Text(this.message)
      Text('我是文本1').attributeModifier(this.textModifierUpdater)
      Text('我是文本2').attributeModifier(this.textModifierUpdater)
      // darcyRefactor: Data类只能绑定一个组件 文本2生效 文本1不生效
      Button('修改TextData-Blue').width('100%').onClick(() => {
        this.textData.color = Color.Blue
      })
      // darcyRefactor: Data类只能绑定一个组件 文本2生效 文本1不生效
      Button('修改TextData-Red').width('100%').onClick(() => {
        this.textData.color = Color.Red
      })
    }
    .height('100%')
    .width('100%')
  }
}