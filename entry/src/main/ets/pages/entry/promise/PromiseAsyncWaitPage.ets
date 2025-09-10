import { test_async_wait_func, test_promise_func } from '../../../learn/unittest/PromiseAndAsyncWait'

@Entry
@Component
struct PromiseAsyncWaitPage {
  build() {
    Column({ space: 5 }) {
      Text('PromiseAsyncWaitPage')
      Button('Promise').width('100%').onClick(() => {
        test_promise_func()
      })
      Button('async/wait').width('100%').onClick(() => {
        test_async_wait_func()
      })
    }.height('100%')
    .width('100%')
  }
}