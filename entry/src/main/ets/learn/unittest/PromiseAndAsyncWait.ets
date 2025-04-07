import { Log } from "static_common";

export function test_promise_func() {
  const promise: Promise<number> = new Promise((resolve, reject) => {
    setTimeout(() => {
      const result: number = Math.random();
      if (result > 0.5) {
        resolve(result);
      } else {
        reject(new Error('Error: random number is too small.'));
      }
    }, 3_000);
  });
  Log.log(`promise start`);
  promise.then((result) => {
    Log.log(`Promise resolved with result: ${result}`);
  }, (reason: string) => {
    Log.log(`Promise rejected with reason: ${reason}`);
  }).catch((error: Error) => {
    Log.error(`Promise rejected with error: ${error.message}`);
  });
  console.log(`promise end`);
}


export async function test_async_wait_func(): Promise<number> {
  console.log(`async start`)
  let promise = new Promise<number>((resolve, reject) => {
    setTimeout(() => {
      const result: number = Math.random()
      if (result > 0.5) {
        resolve(result)
        Log.log(`Promise resolved with result: ${result}`)
      } else {
        Log.error(`Promise rejected with reason: Error: random number is too small.`)
        reject(new Error('Error: random number is too small.'))
      }
    }, 3_000)
  })
  let result = await promise
  Log.log(`async end`)
  return result

}
export async function test_await_func(){
  let result = await get_async_number()
  // darcyRefactor: 获取 async 的值
  Log.log(`await result=${result.valueOf()}`)
  return result
}

export async function get_async_number() {
  return new Promise<number>((resolve, reject) => {
    setTimeout(() => {
      const result: number = Math.random()
      if (result > 0.5) {
        resolve(result)
        Log.log(`Promise resolved with result: ${result}`)
      } else {
        Log.error(`Promise rejected with reason: Error: random number is too small.`)
        reject(new Error('Error: random number is too small.'))
      }
    }, 3_000)
 })
}