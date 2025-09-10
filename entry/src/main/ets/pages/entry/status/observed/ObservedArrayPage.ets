let NextID_: number = 1;

@Observed
class Info {
  public id: number;
  public value: number;

  constructor(value: number) {
    this.id = NextID_++;
    this.value = value;
  }
}

@Component
struct ChildArrayItem {
  // 子组件Child的@ObjectLink的类型是Info
  @ObjectLink info: Info;
  label: string = 'ViewChild';

  build() {
    Row() {
      Button(`ViewChild [${this.label}] this.info.info = ${this.info ? this.info.value : "undefined"}`)
        .width('100%')
        .margin(10)
        .onClick(() => {
          this.info.value += 1;
        })
    }
  }
}

@Entry
@Component
struct ObservedArrayPage {
  // Parent中有@State装饰的Info[]
  @State arrA: Info[] = [new Info(0), new Info(0)];

  build() {
    Column() {
      Text('for-each 创建子组件')
      ForEach(this.arrA,
        (item: Info) => {
          ChildArrayItem({ label: `#${item.id}`, info: item })
        },
        (item: Info): string => item.id.toString()
      )
      Text('index 创建子组件')
      // 使用@State装饰的数组的数组项初始化@ObjectLink，其中数组项是被@Observed装饰的Info的实例
      ChildArrayItem({ label: `ViewChild this.arrA[first]`, info: this.arrA[0] })
      ChildArrayItem({ label: `ViewChild this.arrA[last]`, info: this.arrA[this.arrA.length-1] })

      Text('数组操作')
      Button(`ViewParent: reset array`)
        .width('100%')
        .margin(10)
        .onClick(() => {
          this.arrA = [new Info(0), new Info(0)];
        })
      Button(`ViewParent: push`)
        .width('100%')
        .margin(10)
        .onClick(() => {
          this.arrA.push(new Info(0));
        })
      Button(`ViewParent: shift`)
        .width('100%')
        .margin(10)
        .onClick(() => {
          if (this.arrA.length > 0) {
            this.arrA.shift();
          } else {
            console.log("length <= 0");
          }
        })
      Button(`ViewParent: item property in middle`)
        .width('100%')
        .margin(10)
        .onClick(() => {
          this.arrA[Math.floor(this.arrA.length / 2)].value = 10;
        })
      Button(`ViewParent: item property in middle`)
        .width('100%')
        .margin(10)
        .onClick(() => {
          this.arrA[Math.floor(this.arrA.length / 2)] = new Info(11);
        })
    }
  }
}