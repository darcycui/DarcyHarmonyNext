import { Log } from 'static_library_common';

let NextID1: number = 1;

@Component
struct ItemView {
  // 子组件ViewA的@ObjectLink的类型是ClassA
  @ObjectLink @Watch('onAChanged') a: ClassA;
  label: string = 'ViewA1';

  build() {
    Row() {
      Text(`ItemView [${this.label}] ${this.a.c}  Click`)
        .onClick(() => {
          this.a.c += 1;
        })
    }
  }

  onAChanged(changedPropertyName: string) {
    Log.log(`onAChanged: ${this.a}`);
  }
}

@Component
struct ListComponent {
  @ObjectLink arrA: ClassAArray;

  build() {
    Column() {
      List() {
        ForEach(this.arrA,
          (item: ClassA) => {
            ListItem() {
              ItemView({ label: `#${item.id}`, a: item }).margin(5)
            }
          },
          (item: ClassA) => item.id.toString()
        )
      }.width('100%')
    }
  }
}

@Entry
@Component
struct ListA1 {
  // ViewB中有@State装饰的ClassA[]
  @State classB: ClassB = new ClassB()

  aboutToAppear(): void {
    this.classB.arrA.push(new ClassA(1), new ClassA(2));
  }

  build() {
    Column() {
      Button(`ListA1: change item property in middle`).width('100%')
        .margin({ top: 20 })
        .onClick(() => {
          // this.arrA.arrA[Math.floor(this.arrA.arrA.length / 2)].c = 10;
          this.classB.change();
        })
      ListComponent({ arrA: this.classB.arrA })
    }
  }
}

@Observed
class ClassA {
  @Track public id: number;
  @Track public c: number;

  constructor(c: number) {
    this.id = NextID1++;
    this.c = c;
  }
}

@Observed
export class ClassAArray extends Array<ClassA> {
}

@Observed
class ClassB {
  // @Track arrA: ClassAArray = [new ClassA(0), new ClassA(0)];
  @Track arrA: ClassAArray = new ClassAArray();

  // constructor() {
  //   this.arrA.push(new ClassA(1), new ClassA(2));
  // }

  change() {
    this.arrA[Math.floor(this.arrA.length / 2)].c += 10;
  }
}

function getItem(item: ClassA): ClassA {
  return item;
}
