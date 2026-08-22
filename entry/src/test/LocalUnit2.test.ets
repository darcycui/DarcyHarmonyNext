import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Log } from 'static_library_common';

function compare(x: number, y: number) {
  Log.log(`x=${x}, y=${y}`)
  if (x > y) {
    Log.log("x比y大")
  } else {
    Log.log("x不比y大")
  }
}

class Dog {
}

class Cat {
}

// 类型别名
type Animal = Dog | Cat | null | undefined // 联合类型
type CompareFunction = (x: number, y: number) => boolean
let compareFunctionImpl: CompareFunction = (x: number, y: number): boolean => {
  let result = x > y
  Log.log("x比y大:" + result)
  return result
}

class Person {
  public name: string
  public age: number

  constructor(name: string)

  constructor(name: string, age: number)

  constructor(name: string = "", age: number = 0) {
    this.name = name
    this.age = age
  }

  info(): string {
    return "name:" + this.name + " age:" + this.age
  }
}

// 对象字面量的类
class ObjectLiteral {
  public name: string = ""
  age: number = 18 // 默认可见性: public
}

function checkAnimal(animal: Animal) {
  // == 只比较值
  // === 比较值和类型
  // animal == null 包含两种情况: animal===null 和 animal===undefined
  if (animal === null) {
    Log.log("动物为null")
  } else if (animal === undefined) {
    Log.log("动物未定义")
  } else if (animal instanceof Dog) {
    Log.log("这个动物是狗")
  } else if (animal instanceof Cat) {
    Log.log("这个动物是猫")
  } else {
    Log.log("未知动物")
  }
}

export default function localUnitTest2() {


  describe("localUnittest2", () => {
    it("test_value_variate", 0, () => {
      let name: string = "张三"
      Log.log("name:" + name)
      name = "李四"

      Log.log("name更新后:" + name)
      const address: string = "北京"
      Log.log("address:" + address)
      // address = "上海" // 编译错误

      let int = 10
      Log.log("number:" + int)
      let float = 3.14
      Log.log("float:" + float)
      let isFull = true
      Log.log("isFull:" + isFull)
      compare(int, float)
      compareFunctionImpl(int, float)

      let str = '单引号字符串'
      let str2 = "双引号字符串"
      let str3 = `反引号字符串 number=${int}`
      Log.log("str:" + str)
      Log.log("str2:" + str2)
      Log.log("str4:" + str3)

      let names: string[] = ["张三", "李四", "王五"]
      Log.log("names:" + names)
      // 推荐使用 for-of 遍历数组
      for (let item of names) {
        Log.log("for-of遍历(推荐) item=" + item)
      }
      for (let entry of names.entries()) {
        let index = entry[0]
        let item = entry[1]
        Log.log("for-of遍历带索引(推荐) item=" + item + " index=" + index)
      }
      for (let i = 0; i < names.length; i++) {
        Log.log("for循环遍历 item=" + names[i] + " index=" + i)
      }
      names.forEach((item: string, index: number) => {
        Log.log("forEach遍历 item=" + item + " index=" + index)
      })


      let obj1: Object = '张三'
      let obj2: Object = 10
      let obj3: Object = 3.14
      let obj4: Object = ["张三", "李四", "王五"]
      let obj = obj1
      switch (obj) {
        case obj1:
          Log.log("obj的类型 obj1")
          break;
        case obj2:
          Log.log("obj的类型 obj2")
          break;
        case obj3:
          Log.log("obj的类型 obj3")
          break;
        default:
          Log.log("obj的类型 未知")
          break;
      }

      enum ColorSet {
        Red = 1,
        Green = 2,
        Blue = 3,
      }

      let color: ColorSet = ColorSet.Red
      Log.log("color=" + color)

      checkAnimal(new Dog())
      checkAnimal(new Cat())
      checkAnimal(null)
      checkAnimal(undefined)

      let dog: Dog | null = new Dog()
      Log.log("dog1:" + dog)
      dog = null
      Log.log("dog1 置空:" + dog)
      let dog2 = dog ?? new Dog()
      Log.log("dog2:" + dog2)

      // if表达式可以是任何类型 非boolean类型会自动转换
      if (dog2) {
        Log.log("dog2不为空")
      } else {
        Log.log("dog2为空")
      }

      let a = 2
      let price = a > 10 ? 10 : a
      Log.log("price:" + price)

      try {
        let x = 0
        let score = 1 / x
        Log.log("score=" + score)
        throw new Error("除0错误")
      } catch (e) {
        let error = e as (Error | null)
        Log.log("异常error:" + error)
      } finally {
        Log.log("finally 语句执行")
      }

      let person: ObjectLiteral = { name: "张三", age: 18 }
      Log.log("person: " + person.name + " " + person.age)

    })
  })
}