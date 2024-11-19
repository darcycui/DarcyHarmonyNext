import { Log } from 'static_common';

export interface IPerson {
  showInfo(): void;

  // FIXME: 定义一个带默认实现的方法
  // defaultFunction():void;

  // TODO 接口属性
  //  等同于get field()和set field()方法
  field: string

  // TODO:声明get()和set()方法
  // get field()
  //
  // set field(field: string)
}

export class BasePerson implements IPerson {
  // 实现接口属性
  field: string = "BasePerson field";

  showInfo(): void {
    Log.log("BasePerson implements IPerson:showInfo()")
  }
}

export class AbsPerson implements IPerson {
  showInfo(): void {
    throw new Error('Method not implemented.');
  }

  private innerField: string = ""

  // TODO:实现get field() 和 set field()
  get field(): string {
    return "AbsPerson field"
  }

  set field(filed: string) {
    this.innerField = filed
  }
}