import { test_async_wait_func, test_promise_func } from '../../../learn/unittest/PromiseAndAsyncWait'

@Entry
@Component
struct PromiseAsyncWaitPage {
  build() {
    Column(){
      Text('PromiseAsyncWaitPage')
      Button('Promise').onClick(()=>{
        test_promise_func()
      })
      Button('async/wait').onClick(()=>{
        test_async_wait_func()
      })
    }.height('100%')
    .width('100%')
  }
}