import { Log } from 'static_library_common';
import test_async_wait from './AsyncWait.test';
import localUnitTest from './LocalUnit.test';
import test_promise from './Promise.test';

export default function testsuite() {
  localUnitTest();
  test_promise();
  test_async_wait();
}

/**
 * 函数
 * TODO:使用function声明
 * TODO:export导出
 * @param a
 * @param b
 * @returns
 */
export function add(a: number, b: number): number {
  Log.log(`add() a=${a} b=${b}`);
  return a + b
}

/**
 * 函数
 * @param a 必选参数
 * @param b TODO:可选参数 默认值:10
 * @returns
 */
export function addDefault(a: number, b: number = 10): number {
  return a + b
}

/**
 * void返回类型(可省略)
 * @param name
 */
export function hello(name: string): void {
  Log.log(`Hello ${name}`)
}

export function addRest(...numbers: number[]): number {
  let result = 0;
  for (let n of numbers) {
    result += n;
  }
  return result;
}

// 定义函数类型 TODO:箭头后跟返回值类型
export type TrigFun = (x: number, y: number) => number

/**
 * 高阶函数
 * @param f:函数类型
 */
export function doAction(f: TrigFun) {
  f(10, 20)
}

// 箭头函数 lambda函数 TODO:箭头后跟函数体
export let lambda = (x: number, y: number): number => {
  return x + y
}

export let lambda2 = (x: number, y: number) => {
  return x + y;
}

export let lambda3 = (x: number, y: number) => x + y;

export function tryLambda(lambda: (x: number, y: number) => number) {
  let result = lambda(100, 200)
  Log.log("tryLambda result=" + result);
}

// 闭包 TODO:返回函数类型
export function f(): () => number {
  let count = 0;
  let g = (): number => {
    // g()函数可以访问count变量
    count++;
    return count
  }
  return g
}

// 函数重载
// 函数声明1 不带函数体
export function foo(): void;

//函数声明2 不带函数体
export function foo(name: string): void;

//函数声明3 不带函数体
export function foo(id: number): void;

//函数实现 带方法体 TODO:注意这里使用联合类型 参数可选(有默认值)
export function foo(x: string | number | null = null) {
  Log.log("foo-" + x)
}

// 泛型方法
export function last<T>(x: T[]) {
  return x[x.length-1]
}