import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Colors } from '@ohos.arkui.theme';
import {
  add,
  addDefault,
  addRest,
  doAction,
  f,
  foo,
  hello,
  lambda,
  lambda2,
  lambda3,
  last,
  TrigFun,
  tryLambda
} from './List.test';
import { Person } from '../main/ets/learn/Person';
import { GenericClass } from '../main/ets/learn/GenericClass';
import { Teacher, School } from '../main/ets/learn/School'
import { Log } from 'static_common';

export default function localUnitTest() {
  describe('localUnitTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });
    it('assertContain', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'abc';
      let b = 'b';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertContain(b);
      expect(a).assertEqual(a);
    });

    //TODO 学习笔记 变量和常量
    it("learnValue", 0, () => {
      // let声明变量 变量名在前; TODO:变量类型小写
      let hi: string = 'hello';
      // 打印hi TODO:注意这里的字符串打印使用+连接
      Log.log("hi=" + hi);
      // 变量可以修改
      hi = 'hello world';
      Log.log("hi=" + hi);
      // const声明常量
      const hello: string = "const hello";
      Log.log("hello=" + hello);
      // 常量不可以修改
      // hello = "const hello world"

      // 初始化时的类型推断
      let num = 1;
      Log.log("num=" + num);
      let str = "ABC";
      Log.log("str=" + str);

      // 数字类型
      let n1 = 1;
      Log.log("n1=" + n1);
      let n2 = 3.14;
      Log.log("n2=" + n2);
      let n3 = .5;
      Log.log("n3=" + n3);
      let n4 = 1e2;
      Log.log("n4=" + n4);

      // 布尔类型
      let isDone = false;
      let isSuccess = true;
      Log.log("isDone=" + isDone);
      Log.log("isSuccess=" + isSuccess);

      // 字符串类型
      // 使用双引号创建字符串
      let s1 = "Hello, world!\n";
      Log.log("s1=" + s1);
      // TODO:使用单引号声明字符串
      let s2 = 'this is a string';
      Log.log("s2=" + s2);
      //
      let a = 'Success';
      // 使用字符串模板创建字符串? TODO:注意格式`` ${}
      let s3 = `The result is ${a}`;
      Log.log("s3=" + s3);

      // Void类型
      // 用于函数返回值

      // void是引用类型 可以用于泛型
      class Class<T> {
      }

      let instance: Class<void>

      // Object类型
      // 数组类型 TODO:使用[]声明
      let names: string[] = ["Tom", "Jerry"];
      // Enum类型 TODO:使用{}声明
      // 枚举 枚举值默认
      enum ColorSet {Red, Green, Blue}

      let c: ColorSet = ColorSet.Red;
      Log.log("enum c=" + c)

      // 枚举带自定义枚举值
      enum ColorSet2 {Red = 0xFF, Green = 0x7f, Blue = 0x00}

      let c2: ColorSet2 = ColorSet2.Green;
      Log.log("enum c2=" + c2);

      // Union类型
      class Dog {
      }

      class Cat {
      }

      class Frog {
      }

      // TODO 联合类型 使用|声明
      type Animal = Dog | Cat | Frog;
      let animal: Animal = new Dog();
      animal = new Cat();
      animal = new Frog();

      // 区分Union类型的真实类型 instanceof
      if (animal instanceof Cat) {
        Log.log("This is a cat.");
      } else if (animal instanceof Dog) {
        Log.log("This a dog.");
      } else if (animal instanceof Frog) {
        Log.log("This is a frog.");
      }

      // Aliases类型 为匿名类型(数组/函数/联合类型/对象字面量?)设置类型,为已有类型设置别名
      // 数组
      type Matrix = Number[][];
      // 匿名函数 TODO:使用=>声明
      type Handler = (s: string, no: number) => string;
      // 联合类型
      type NullableObject = object | null;
      // 带泛型的匿名函数
      type Predicate<T> = (t: T) => boolean;
      // 已知类型设置别名
      type MyString = string;
      let myStr: MyString = "ABC";
      Log.log("myStr=" + myStr)

    })

    //TODO 学习笔记运算符 条件语句 循环语句
    it("learnSymbol", 0, () => {
      let a = 10;
      let b = 2;
      let c = a + b;
      Log.log("c=" + c);
      let d = a - b;
      Log.log("d=" + d);
      let e = a * b;
      Log.log("e=" + e);
      let f = a / b;
      Log.log("f=" + f);
      a++;
      Log.log("a=" + a);
      b--;
      Log.log("b=" + b)

      // TODO: === 和 == 的区别?
      if (a == 11) {
        Log.log("a==11");
      }
      if (a == 11.0) {
        Log.log("a==11.0");
      }
      if (a === 11) {
        Log.log("a===11");
      }
      if (a === 11.0) {
        Log.log("a===11.0");
      }

      // 条件判断
      let hello = "Hello";
      // TODO:条件可以是任何类型?
      if (hello) {
        Log.log("hello is True.");
      }

      // switch语句 需要break
      let score = 80;
      switch (score) {
        case 90:
          Log.log("score=90");
          break
        case 80:
          Log.log("score=80")
          break;
        default:
          Log.log("score default")
          break;
      }

      // 条件表达式
      let isValid = Math.random() > 0.5 ? true : false;
      Log.log("isValid=" + isValid);

      // for循环
      let sum = 0;
      // TODO:注意这里 let声明变量i
      for (let i = 0; i < 10; i++) {
        sum += i;
      }
      Log.log("sum=" + sum);

      // for-of循环
      let names: string[] = ["Tom", "Jerry", "Spike", ""];
      // TODO:注意这里 let声明变量s
      for (let s of names) {
        Log.log("s=" + s);
      }

      // while循环
      let i = 0;
      let sum2 = 0;
      while (i < 10) {
        sum2 += i;
        i++;
      }
      Log.log("sum2=" + sum2);

      // do-while
      let x = 10;
      do {
        Log.log("do x=" + x);
        x++;
      } while (x < 10)
      Log.log("x=" + x);
    })

    //TODO 学习笔记 函数
    it("learnFunction", 0, () => {
      // 普通函数
      let sum = add(1, 2);
      Log.log("sum=" + sum);

      // 可选参数函数 参数默认值
      let sum2 = addDefault(1);
      Log.log("sum2=" + sum2);

      // void 函数
      hello("Tom");

      // 可变长参数函数
      let sum3 = addRest(1, 2, 3, 4, 5);
      Log.log(`sum3=${sum3}`);

      // 函数类型(常用于定义回调)
      doAction(add);
      doAction(lambda);

      // 箭头函数 lambda函数
      tryLambda(lambda);
      tryLambda(lambda2);
      tryLambda(lambda3);

      // 闭包
      let z = f();
      let result1 = z();
      let result2 = z();
      let result3 = z();
      Log.log(`result1=${result1}`); //result=1
      Log.log(`result2=${result2}`); //result=2
      Log.log(`result3=${result3}`); //result=3

      // 重载
      foo();
      foo(101);
      foo("Tom")

    })

    //TODO 学习笔记 类
    it("learnClass", 0, () => {
      // 创建类的实例 TODO:注意new关键字
      let tom = new Person("John", "Smith");
      // 调用函数
      let info = tom.fullName();
      Log.log("fullName=" + info);
      // 访问属性
      let name = tom.getName();
      Log.log("name=" + name);
      let supername1 = tom.supername;
      Log.log("supername1=" + supername1);
      let supername2 = tom.getSuperName();
      Log.log("supername2=" + supername2);
      // 属性必须初始化 否则类型为undefined TODO:调用方式带问号 可选链(?.)
      let length = tom.mayempty?.length;
      Log.log("mayempty length=" + length); //length=undefined
      tom.setMayEmpty("Has initialization");
      // 可能为undefined的属性 调用方式带问号 可选链(?.)
      let length2 = tom.getMayEmpty()?.length;
      Log.log("mayempty length2=" + length2);
      // 静态属性 TODO:只能通过类名访问
      let staticfield = Person.staticfield
      Log.log("staticfield=" + staticfield)
      // 静态方法
      Person.staticFunction()
      // 调用父类方法
      tom.showInfo()

      // 创建类的实例 TODO:使用对象字面量{}
      // FIXME: Object literal must correspond to some explicitly declared class or interface (arkts-no-untyped-obj-literals)
      // let tom2: Person = {
      //   name: "Tom",
      //   supername: "etc",
      //   fullName(): string {
      //     return ""
      //   }
      // }
      // tom2.fullName()

      class Point {
        x: number = 0
        y: number = 0
      }

      // 创建类的实例 TODO:使用对象字面量(表达式) 类似kotlin的解构声明
      let point: Point = {
        x: 1, y: 1,
      };
      Log.log("point x=" + point.x + " y=" + point.y)

      // Record(map) 使用对象字面量初始化
      let map: Record<string, number> = {
        "John": 25,
        "Mary": 21
      }
      // Record遍历
      // 使用 Object.keys() 和 forEach() 遍历 Record
      Object.keys(map).forEach(key => {
        Log.log(`Key: ${key}, Value: ${map[key]}`);
      });

      // 获取record的值
      Log.log("record John=" + map["John"])
      // 修改record的值
      map["John"] = 24
      Log.log("record John=" + map["John"])

      // record的K只能是string或number
      let map2: Record<number, Point> = {
        1: {
          x: 1, y: 1
        },
        2: {
          x: 2, y: 2
        }
      }
      Log.log("record2 point1=" + map2[1].x + " " + map2[1].y)

    })

    //TODO 学习笔记 泛型
    it("learnGeneric", 0, () => {
      // 泛型类 TODO:泛型可以省略
      let num = new GenericClass(1)
      Log.log("num=" + num.getValue())
      let str = new GenericClass<string>("hello generic")
      Log.log("str=" + str.getValue())

      // 泛型方法 TODO:泛型可以省略
      let lastn = last([1, 2, 3, 4, 5])
      Log.log("lastn=" + lastn);
      let laststr = last<string>(["Hello", "World", "Welcome"])
      Log.log("laststr=" + laststr);
    })
    // TODO 学习笔记 数组
    it("learnArray", 0, () => {
      let array: number[] | null = null
      Log.log("array=" + array)
      // TODO []创建array
      array = [];
      Log.log("array=" + array)
      // TODO:在尾部添加元素 push
      array.push(100)
      array.push(200)
      // TODO:在头部添加元素 unshift
      array.unshift(300)
      Log.log("array=" + array)
      // 通过下标访问array
      Log.log("array[0]=" + array[0])
      // TODO:从尾部移除元素 pop
      array.pop()
      Log.log("array=" + array)
      // TODO:从头部移除元素 shift
      array.shift()
      Log.log("array=" + array)
    })

    //TODO 学习笔记 空安全
    it("learnNullSafety", 0, () => {
      // 类型的默认值不是null TODO:不可以赋值为null
      // let num: number = null;
      // let str: string = null;
      // let array: number[] = null;

      // TODO 声明为联合类型 可以赋值为null
      let num: number | null = null;
      let str: string | null = null;
      let array: number[] | null = null;

      // TODO 非空断言 !(如果为null会抛运行时异常)
      // let length1 = str!.length
      // Log.log("length1=" + length1)

      str = "hello harmony";
      let length2 = str!.length;
      Log.log("length2=" + length2);

      // TODO 空值合并(??) undefined/null
      let nick: string | null | undefined = undefined;
      let realnick1 = nick ?? "Default Nick1";
      Log.log("nick=" + nick + " realnick1=" + realnick1);
      nick = null;
      let realnick2 = nick ?? "Default Nick2";
      Log.log("nick=" + nick + " realnick2=" + realnick2);
      nick = "Tom";
      let realnick3 = nick ?? "Default Nick3";
      Log.log("nick=" + nick + " realnick3=" + realnick3);
      // TODO 空值合并变量的使用 带小括号()
      let nicklength = (nick ?? "").length
      Log.log("nicklength=" + nicklength)

      // TODO 可选链(?.) 优先级:类的属性是undefined或者null 可选链回返回undefined
      let school = new School()
      let name1 = school.getTeacherName()
      Log.log("teacher name1=" + name1)
      school.setTeacher(new Teacher("Teacher Tom"))
      let name2 = school.getTeacherName()
      Log.log("teacher name2=" + name2)
    })
  });
}