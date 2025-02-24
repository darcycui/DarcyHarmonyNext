import { HashMap, JSON } from '@kit.ArkTS';
import { Log } from 'static_common';

@Entry
@Component
struct StatePage {
  // class类型 嵌套赋值观察不到!
  @State model: Model = new Model('Hello', new Person('World'));
  // 数组类型 嵌套赋值观察不到!
  @State array: Person[] = [new Person('Tom'), new Person('Jerry')];
  // Date类型
  @State selectedDate: Date = new Date('2021-08-08');
  // map类型
  @State map: Map<string, Person> =
    new Map([['one', new Person('1')], ['two', new Person('2')], ['three', new Person('3')]]);
  @State set: Set<Person> = new Set([new Person('001'), new Person('002'), new Person('003')])
  person4 = new Person('444')

  build() {
    // 滚动组件
    Scroll() {
      Column() {
        this.testSetState()
        this.testMapState()
        this.testArrayState()
        this.testClassState()
        this.testDateState()
      }.alignItems(HorizontalAlign.Start)
      // .height('100%') // 不能指定height 否则Scroll不能滚动
      .width('100%')
    }
    .scrollable(ScrollDirection.Vertical)
    .height('100%')
    .width('100%')
  }

  @Builder
  testSetState() {
    Text(getSetString(this.set)).fontSize(20).margin({ top: 20 })
    Button('set 赋值').onClick(() => {
      this.set = new Set([new Person('100'), new Person('200'), new Person('300')])
    }).margin({ top: 10 })
    Button('set item新增').onClick(() => {
      this.set.add(this.person4)
    }).margin({ top: 10 })
    Button('set item删除').onClick(() => {
      this.set.delete(this.person4)
    }).margin({ top: 10 })
    Button('set 清空').onClick(() => {
      this.set.clear()
    }).margin({ top: 10 })
    // TODO 无法观察到!
    Button('set item属性嵌套赋值').onClick(() => {
      // set 遍历
      for (let item of this.set) {
        Log.log(`item= ${item.value}`)
        if (item.value == '100') {
          item.value = '-888'
          Log.warn(`item changed`)
        }
      }
      for (let item of this.set) {
        Log.log(`item= ${item.value}`)
      }
    }).margin({ top: 10 })
  }

  @Builder
  testMapState() {
    Text(getMapString(this.map)).fontSize(20).margin({ top: 20 })
    Button('map 赋值').onClick(() => {
      Log.log(`1 ${this.map.get('one')?.value}`)
      this.map = new Map([['第一', new Person('111')], ['第二', new Person('222')], ['第三', new Person('333')]]);
      Log.log(`1 ${this.map.get('第一')?.value}`)
    }).margin({ top: 10 })
    Button('map item赋值').onClick(() => {
      this.map.set('第一', new Person('-101'));
      Log.log(`1 ${this.map.get('第一')?.value}`)
    }).margin({ top: 10 })
    Button('map item新增').onClick(() => {
      this.map.set('第四', new Person('444'))
      Log.log(`4 ${this.map.get('第四')?.value}`)
    }).margin({ top: 10 })
    Button('map item删除').onClick(() => {
      this.map.delete('第四')
      Log.log(`4 ${this.map.get('第四')?.value}`)
    }).margin({ top: 10 })
    Button('map 清空').onClick(() => {
      this.map.clear()
    }).margin({ top: 10 })
    // TODO 无法观察到!
    Button('map item属性嵌套赋值').onClick(() => {
      let original: Person | undefined = this.map.get('第一')
      Log.log(`original=${original?.value}`);
      if (original != undefined) {
        original.value = '999';
        Log.info(`original is changed`)
        Log.log(`original=${original?.value}`);
      } else {
        Log.error(`original is undefined`)
      }
    }).margin({ top: 10 })
  }

  @Builder
  testArrayState() {
    Text(JSON.stringify(this.array)).fontSize(20).margin({ top: 20 })
    Button('array 赋值').onClick(() => {
      this.array = [new Person('汤姆'), new Person('杰瑞')];
    }).margin({ top: 10 })
    Button('array item赋值').onClick(() => {
      this.array[1] = new Person('斯派克');
    }).margin({ top: 10 })
    Button('array item新增').onClick(() => {
      this.array.push(new Person('多盖洛'));
    }).margin({ top: 10 })
    Button('array item删除').onClick(() => {
      this.array.pop();
    }).margin({ top: 10 })
    Button('map 清空').onClick(() => {
      this.array.length = 0
    }).margin({ top: 10 })
    // TODO 无法观察到!
    Button('array item属性嵌套赋值').onClick(() => {
      this.array[0].value = '猫和老鼠';
    }).margin({ top: 10 })
  }

  @Builder
  testClassState() {
    Text(JSON.stringify(this.model)).fontSize(20)
    Button('class 赋值').onClick(() => {
      this.model = new Model('Hi', new Person('ArkUI'));
    }).margin({ top: 10 })
    Button('class 属性赋值').onClick(() => {
      this.model.value = '你好';
      this.model.name = new Person('世界');
    }).margin({ top: 10 })
    // TODO 无法观察到!
    Button('class 属性嵌套赋值').onClick(() => {
      this.model.name.value = '我的世界';
    }).margin({ top: 10 })
  }

  @Builder
  testDateState() {
    Text(JSON.stringify(this.selectedDate)).fontSize(20).margin({ top: 20 })
    Button('set selectedDate to 2023-07-08')
      .margin(10)
      .onClick(() => {
        this.selectedDate = new Date('2023-07-08');
      })
    Button('increase the year by 1')
      .margin(10)
      .onClick(() => {
        this.selectedDate.setFullYear(this.selectedDate.getFullYear() + 1);
      })
    Button('increase the month by 1')
      .margin(10)
      .onClick(() => {
        this.selectedDate.setMonth(this.selectedDate.getMonth() + 1);
      })
    Button('increase the day by 1')
      .margin(10)
      .onClick(() => {
        this.selectedDate.setDate(this.selectedDate.getDate() + 1);
      })
    DatePicker({
      start: new Date('1970-1-1'),
      end: new Date('2100-1-1'),
      selected: this.selectedDate
    })
  }
}

class Person {
  public value: string;

  constructor(value: string) {
    this.value = value;
  }
}

class Model {
  public value: string;
  public name: Person;

  constructor(value: string, person: Person) {
    this.value = value;
    this.name = person;
  }
}

function getMapString(map: Map<string, Person>): string {
  let mapString = '';
  map.forEach((value, key) => {
    mapString += `${key}: ${value.value}, `;
  })
  return mapString
}

function getSetString(set: Set<Person>): string {
  let setString = '';
  set.forEach((value) => {
    setString += `${value.value}, `;
  })
  return setString
}

