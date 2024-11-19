import { Log } from 'static_common';
import { BasePerson } from './IPerson';

/**
 * Person子类继承父类BasePerson
 */
export class Person extends BasePerson {
  // 属性(必须在声明处或者构造函数中初始化)
  private name: string = "";
  // 默认可见性为 public
  supername: string = "";

  // TODO 构造函数重载 先声明后实现
  // 声明重载函数1
  constructor();

  // 声明重载函数2
  constructor(name: string);

  // 声明重载函数3
  constructor(name: string, supername: string);

  // 构造函数实现
  constructor(name: string = "", supername: string = "") {
    // 调用父类构造函数
    super();
    this.name = name;
    this.supername = supername;
  }

  // 普通方法 TODO:不需要function关键字
  // 默认可见性为 public
  fullName(): string {
    return this.name + " " + this.supername;
  }

  // get/set方法
  getName(): string {
    // TODO:注意这里的this不能省略
    return this.name
  }

  setName(name: string) {
    this.name = name;
  }

  getSuperName(): string {
    return this.supername;
  }

  setSuperName(supername: string) {
    this.supername = supername;
  }

  // 属性 可能为undefined TODO:注意问号的位置在冒号前 ?:string
  mayempty?: string

  // TODO: 注意返回值类型为联合类型
  getMayEmpty(): string | undefined {
    return this.mayempty
  }

  setMayEmpty(mayempty: string) {
    this.mayempty = mayempty
  }

  // 静态属性
  static staticfield: number = 998

  // 静态方法
  static staticFunction(): void {
    Log.log("This is a static function")
  }
}