class Balloon {
  volume: number;

  constructor(volume: number) {
    this.volume = volume;
  }

  static increaseVolumeStatic(balloon: Balloon) {
    balloon.volume += 2;
  }

  increaseVolumeNormal(balloon: Balloon) {
    balloon.volume += 2;
  }

  increaseVolumeWithoutParams() {
    this.volume += 2;
  }
}

@Entry
@Component
struct StateChangedPage5 {
  @State balloon: Balloon = new Balloon(10);

  reduceVolumeThis(balloon: Balloon) {
    balloon.volume -= 1;
  }
  reduceVolumeThisWithoutParams() {
    this.balloon.volume -= 1;
  }

  build() {
    Column({ space: 8 }) {
      Text(`The volume of the balloon is ${this.balloon.volume} cubic centimeters.`)
        .fontSize(20)
      Button(`increaseVolume`)
        .width('100%').onClick(() => {
          // TODO 将状态作为参数传递给其他类的静态函数，无法触发UI刷新
          // Balloon.increaseVolumeStatic(this.balloon);

          // TODO 将状态作为参数传递给其他类的普通函数，无法触发UI刷新
          // this.balloon.increaseVolumeNormal(this.balloon);

          // 解决方法: 创建一个新的变量传递给静态函数
          let balloon1 = this.balloon;
          // Balloon.increaseVolumeStatic(balloon1);
          this.balloon.increaseVolumeNormal(balloon1);
        })
      Button(`reduceVolume`)
        .width('100%').onClick(() => {
          // TODO 使用this内部函数调用，无法触发UI刷新
          // this.reduceVolumeThis(this.balloon);

          // 解决方法: 创建一个新的变量传递给静态函数
          let balloon1 = this.balloon;
          this.reduceVolumeThis(balloon1);
        })

      Button(`reduceVolume2`)
        .width('100%').onClick(() => {
          // TODO 直接调用其他类的函数 不传递状态参数，可以触发UI刷新
          // this.balloon.increaseVolumeWithoutParams()
          // TODO 直接调用this内部函数 不传递状态参数，可以触发UI刷新
          this.reduceVolumeThisWithoutParams()
        })
      Button(`reduceVolume3`)
        .width('100%').onClick(() => {
          // TODO 将状态作为参数传递给当前文件外部函数，可以触发UI刷新
          reduceVolumeOut(this.balloon);
        })
    }
    .width('100%')
    .height('100%')
  }
}

function reduceVolumeOut(balloon: Balloon) {
  balloon.volume -= 1;
}