class Balloon {
  volume: number;

  constructor(volume: number) {
    this.volume = volume;
  }

  static increaseVolume(balloon: Balloon) {
    balloon.volume += 2;
  }

  increaseVolume2(balloon: Balloon) {
    balloon.volume += 4;
  }
}

@Entry
@Component
struct StateChangedPage5 {
  @State balloon: Balloon = new Balloon(10);

  reduceVolumeThis(balloon: Balloon) {
    balloon.volume -= 1;
  }

  build() {
    Column({ space: 8 }) {
      Text(`The volume of the balloon is ${this.balloon.volume} cubic centimeters.`)
        .fontSize(20)
      Button(`increaseVolume`)
        .onClick(() => {
          // TODO 通过其他类的静态函数调用，无法触发UI刷新
          // Balloon.increaseVolume(this.balloon);

          // TODO 通过其他类的普通函数调用，无法触发UI刷新
          // this.balloon.increaseVolume2(this.balloon);

          // 解决方法: 创建一个新的变量传递给静态函数
          let balloon1 = this.balloon;
          Balloon.increaseVolume(balloon1);
        })
      Button(`reduceVolume`)
        .onClick(() => {
          // TODO 使用this内部函数调用，无法触发UI刷新
          // this.reduceVolume(this.balloon);
          // 解决方法: 创建一个新的变量传递给静态函数
          let balloon1 = this.balloon;
          this.reduceVolumeThis(balloon1);
        })
      Button(`reduceVolume2`)
        .onClick(() => {
          // TODO 使用当前文件外部函数调用，可以触发UI刷新
          // reduceVolumeOut(this.balloon);
          // 解决方法: 也可以创建一个新的变量传递给静态函数
          let balloon1 = this.balloon;
          reduceVolumeOut(balloon1);
        })
    }
    .width('100%')
    .height('100%')
  }
}

function reduceVolumeOut(balloon: Balloon) {
  balloon.volume -= 2;
}