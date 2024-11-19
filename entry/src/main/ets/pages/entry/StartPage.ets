import {
  PAGE_CAMERA_STATIC,
  PAGE_COLUMN,
  PAGE_HTTPS,
  PAGE_HTTPS_CERT_PIN,
  PAGE_IMAGE,
  PAGE_INPUT,
  PAGE_RELATIVE,
  PAGE_SHARED_INNER,
  PAGE_SHARED_LIBRARY,
  PAGE_STATIC_INNER,
  PAGE_STATIC_LIBRARY,
  PAGE_WEBSOCKETS
} from '../PageName';
import { startNamedPage, startPage } from '../../utils/RouterHelper';
import { common } from '@kit.AbilityKit';
import { EntryEvent } from '../../event/EventName';
import { promptAction } from '@kit.ArkUI';
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
      // 自动换行
      wrap: FlexWrap.Wrap,
      // 主轴对齐方式
      justifyContent: FlexAlign.SpaceEvenly,
      // 交叉轴对齐方式
      alignContent: FlexAlign.SpaceEvenly
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
          startNamedPage(PAGE_CAMERA_STATIC, { 'keyHello': 'Hello World' });
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
        .fontWeight(FontWeight.Bold)
        // .onClick(this.onShow) // 错误:找不到this
        .onClick(()=>{
          this.onShow()
        })
      Button($r('app.string.TestHttpsCertPin'))
        .id('TestHttpsCertPin')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(()=>{
          startPage(PAGE_HTTPS_CERT_PIN, { 'keyHello': 'Hello World' })
        })
      Button($r('app.string.TestHttps'))
        .id('TestHttps')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(()=>{
          startPage(PAGE_HTTPS, { 'keyHello': 'Hello World' })
        })
      Button($r('app.string.TestWebsockets'))
        .id('TestWebsockets')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(()=>{
          startPage(PAGE_WEBSOCKETS, { 'keyHello': 'Hello World' })
        })
    }
    .width('100%')
  }

  onShow() {
    console.log(`StartPage onShow this=${this}`);
    console.log(`stu.getName()=${this.stu?.getName()}`);
    console.log(`stu.name=${this.stu?.name}`);
    console.log(`stu.getAge()=${this.stu?.getAge()}`);
    console.log(`stu.age=${this.stu?.age}`);
  }
}
