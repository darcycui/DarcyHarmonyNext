// objectLinkNestedObjects.ets
let NextIDO2: number = 1;

@Observed
class Name {
  public id: number;
  public length: number;

  constructor(length: number) {
    this.id = NextIDO2++;
    this.length = length;
  }
}

@Observed
class User {
  public name: Name;

  constructor(name: Name) {
    this.name = name;
  }
}

@Component
struct SonObserved2 {
  label: string = 'Son';
  @ObjectLink name: Name;

  build() {
    Column() {
      Text(`Son [${this.label}] this.name.length = ${this.name.length}`)
        .width(320)
        .height(50)
        .margin(10)
        .textAlign(TextAlign.Center)
      Button(`Son: this.name.length add 1`)
        .width(320)
        .backgroundColor('#ff17a98d')
        .margin(10)
        .onClick(() => {
          this.name.length += 1;
        })
    }
  }
}

@Entry
@Component
struct ObservedClassPage2 {
  @State user: User = new User(new Name(0));

  build() {
    Column() {
      SonObserved2({ label: 'Son #1', name: this.user.name }).width(320)
      Button(`GrandFather: this.user.name = new Name(10)`)
        .width(320)
        .margin(10)
        .onClick(() => {
          this.user.name = new Name(10); // 重新赋值name SonObserved2 会更新UI
        })
      Button(`Father: this.user = new User(new Name(20))`)
        .width(320)
        .margin(10)
        .onClick(() => {
          this.user = new User(new Name(20)); // 重新赋值user SonObserved2 会更新UI
        })
    }
  }
}