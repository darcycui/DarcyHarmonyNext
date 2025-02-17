import { DEFAULT, describe, it } from "@ohos/hypium";
import { test_promise_func } from "../main/ets/learn/unittest/PromiseAndAsyncWait";


export default function test_promise() {
  describe('test_promise1', () => {
    it("test_promise2", DEFAULT, () => {
      test_promise_func()
    })
  })

}

