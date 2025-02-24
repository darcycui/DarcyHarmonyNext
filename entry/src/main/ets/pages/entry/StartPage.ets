import {
  PAGE_STATIC_CAMERA,
  PAGE_COLUMN,
  PAGE_FILE,
  PAGE_HTTPS,
  PAGE_HTTPS_CERT_PIN,
  PAGE_IMAGE,
  PAGE_INPUT,
  PAGE_PROMISE_ASYNC_WAIT,
  PAGE_RELATIVE,
  PAGE_SHARED_INNER,
  PAGE_SHARED_LIBRARY,
  PAGE_SP,
  PAGE_STATIC_INNER,
  PAGE_STATIC_LIBRARY,
  PAGE_TASK_POOL,
  PAGE_WEBSOCKETS,
  PAGE_WORKER,
  PAGE_UTD,
  PAGE_KEY_VALUE,
  PAGE_DATABASE,
  PAGE_COMPONENT_STATUS,
  PAGE_STATE,
  PAGE_STATE_CHANGED_1,
  PAGE_STATE_CHANGED_2,
  PAGE_STATE_CHANGED_3,
  PAGE_STATE_CHANGED_4,
  PAGE_STATE_CHANGED_5,
  PAGE_PROP_CHANGED_1,
  PAGE_PROP_CHANGED_2,
  PAGE_LINK
} from '../PageName';
import { startNamedPage, startPage } from '../../utils/RouterHelper';
import { common } from '@kit.AbilityKit';
import { EntryEvent } from '../../event/EventName';
import { LengthUnit, promptAction } from '@kit.ArkUI';
import { nativeAdd } from 'library_camera_static';
import { Student } from '../../bean/HttpBean';

@Entry
@Component
struct StartPage {
  @State message: string = 'Hello World';
  // 获取上下文context
  context = getContext(this) as common.UIAbilityContext;
  @State stu: Student | undefined = new Student("Tom", 7);

  build() {
    Flex({
      // 主轴方向 横向
      direction: FlexDirection.Row,
      // 多行 自动换行
      wrap: FlexWrap.Wrap,
      // 主轴对齐方式
      justifyContent: FlexAlign.Start,
      // 交叉轴对齐方式
      alignItems: ItemAlign.Start,
      // 交叉轴多行 额外空间对齐
      // alignContent: FlexAlign.Center,
      // 间距
      space: {
        // 主轴间距
        main: { value: 5, unit: LengthUnit.VP },
        // 交叉轴间距
        cross: { value: 10, unit: LengthUnit.VP }
      }
    }) {
      Button($r('app.string.RelativePage'))
        .id('RelativePage')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_RELATIVE, { 'keyHello': 'Hello World' });
        })
      Button($r('app.string.InputPage'))
        .id('InputPage')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_INPUT, { 'keyHello': 'Hello World' });
        })
      Button($r('app.string.ColumnPage'))
        .id('ColumnPage')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_COLUMN, { 'keyHello': 'Hello World' });
        })
      Button($r('app.string.ImagePage'))
        .id('ImagePage')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_IMAGE, { 'keyHello': 'Hello World' });
        })
      Button($r('app.string.CameraPage'))
        .id('CameraPage')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          let sum = nativeAdd(1, 2);
          promptAction.showToast({ message: `CameraPage sum=${sum}` })
          startNamedPage(PAGE_STATIC_CAMERA, { 'keyHello': 'Hello World' });
        })
      Button($r('app.string.StaticLibraryPage'))
        .id('StaticLibraryPage')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_STATIC_LIBRARY, { 'keyHello': 'Hello World' });
        })
      Button($r('app.string.SharedLibraryPage'))
        .id('SharedLibraryPage')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_SHARED_LIBRARY, { 'keyHello': 'Hello World' });
        })
      Button($r('app.string.TestEventHub'))
        .id('TestEventHub')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          // TODO 发送事件
          this.context.eventHub.emit(EntryEvent.EVENT_CLICK, 'Tom and Jerry from StartPage');
        })
      Button($r('app.string.TestCallFunction'))
        .id('TestCallFunction')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)// .onClick(this.onShow) // 错误:找不到this
        .onClick(() => {
          this.onShow()
        })
      Button($r('app.string.TestHttpsCertPin'))
        .id('TestHttpsCertPin')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_HTTPS_CERT_PIN, { 'keyHello': 'Hello World' })
        })
      Button($r('app.string.TestHttps'))
        .id('TestHttps')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_HTTPS, { 'keyHello': 'Hello World' })
        })
      Button($r('app.string.TestWebsockets'))
        .id('TestWebsockets')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_WEBSOCKETS, { 'keyHello': 'Hello World' })
        })
      Button($r('app.string.TestFile'))
        .id('TestFile')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_FILE, { 'keyHello': 'Hello World' })
        })
      Button($r('app.string.TestSP'))
        .id('TestSP')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_SP, { 'keyHello': 'Hello World' })
        })
      Button($r('app.string.TestKeyValue'))
        .id('TestKeyValue')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_KEY_VALUE, { 'keyHello': 'Hello World' })
        })
      Button($r('app.string.TestPromiseSyncWait'))
        .id('TestPromiseSyncWait')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_PROMISE_ASYNC_WAIT, { 'keyHello': 'Hello World' })
        })
      Button($r('app.string.TestTaskPoolPage'))
        .id('TestTaskPoolPage')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_TASK_POOL, { 'keyHello': 'Hello World' })
        })
      Button($r('app.string.TestWorkerPage'))
        .id('TestWorkerPage')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_WORKER, { 'keyHello': 'Hello World' })
        })
      Button($r('app.string.TestUTDPage'))
        .id('TestUTDPage')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_UTD, { 'keyHello': 'Hello World' })
        })
      Button($r('app.string.TestDatabasePage'))
        .id('TestDatabasePage')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_DATABASE, { 'keyHello': 'Hello World' })
        })
      Button($r("app.string.TestComponentStatusPage"))
        .id('TestComponentStatusPage')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_COMPONENT_STATUS, { 'keyHello': 'Hello World' })
        })
      Button($r("app.string.TestStatePage"))
        .id('TestStatePage')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_STATE, { 'keyHello': 'Hello World' })
        })
      Button($r("app.string.TestStateChangedPage1"))
        .id('TestStateChangedPage1')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_STATE_CHANGED_1, { 'keyHello': 'Hello World' })
        })
      Button($r("app.string.TestStateChangedPage2"))
        .id('TestStateChangedPage2')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_STATE_CHANGED_2, { 'keyHello': 'Hello World' })
        })
      Button($r("app.string.TestStateChangedPage3"))
        .id('TestStateChangedPage3')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_STATE_CHANGED_3, { 'keyHello': 'Hello World' })
        })
      Button($r("app.string.TestStateChangedPage4"))
        .id('TestStateChangedPage4')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_STATE_CHANGED_4, { 'keyHello': 'Hello World' })
        })
      Button($r("app.string.TestStateChangedPage5"))
        .id('TestStateChangedPage5')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_STATE_CHANGED_5, { 'keyHello': 'Hello World' })
        })
      Button($r("app.string.TestPropPage1"))
        .id('TestPropChangedPage1')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_PROP_CHANGED_1, { 'keyHello': 'Hello World' })
        })
      Button($r("app.string.TestPropPage2"))
        .id('TestPropChangedPage2')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_PROP_CHANGED_2, { 'keyHello': 'Hello World' })
        })
      Button($r("app.string.TestLinkPage"))
        .id('TestLinkPage')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          startPage(PAGE_LINK, { 'keyHello': 'Hello World' })
        })
    }
    .width('100%')
    .height('100%')
  }

  onShow() {
    console.log(`StartPage onShow this=${this}`);
    console.log(`stu.getName()=${this.stu?.getName()}`);
    console.log(`stu.name=${this.stu?.name}`);
    console.log(`stu.getAge()=${this.stu?.getAge()}`);
    console.log(`stu.age=${this.stu?.age}`);
  }
}
