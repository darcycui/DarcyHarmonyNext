import { DEFAULT, describe, it } from "@ohos/hypium"
import { test_async_wait_func, test_await_func } from "../main/ets/learn/unittest/PromiseAndAsyncWait"

export default function test_async_wait() {
  describe('test_async_wait1', () => {
    it("test_async_wait2", DEFAULT, () => {
      test_async_wait_func()
    })
    it("test_await2", DEFAULT, () => {
      test_await_func()
    })
  })

}
