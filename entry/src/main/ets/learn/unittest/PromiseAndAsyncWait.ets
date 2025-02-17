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
  console.log(`promise start`);
  promise.then((result) => {
    console.log(`Promise resolved with result: ${result}`);
  }, (reason: string) => {
    console.log(`Promise rejected with reason: ${reason}`);
  }).catch((error: Error) => {
    console.log(`Promise rejected with error: ${error.message}`);
  });
  // 等待5秒
  console.log(`promise end`);
}


export async function test_async_wait_func(): Promise<number> {
  console.log(`async start`)
  let result = await new Promise<number>((resolve, reject) => {
    setTimeout(() => {
      const result: number = Math.random()
      if (result > 0.5) {
        resolve(result)
        console.log(`Promise resolved with result: ${result}`)
      } else {
        console.log(`Promise rejected with reason: Error: random number is too small.`)
        reject(new Error('Error: random number is too small.'))
      }
    }, 3_000)
  })
  console.log(`async end`)
  return result

}