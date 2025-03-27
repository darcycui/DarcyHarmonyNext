import { promptAction, UIUtils } from '@kit.ArkUI';
import { Log } from 'static_common';

@Entry
@Component
struct StateChangedPage4 {
  list: DataStatePage[] = [new DataStatePage('a'), new DataStatePage('b'), new DataStatePage('c')];
  @State dataObjFromList: DataStatePage = this.list[0];

  build() {
    Column() {
      Text(JSON.stringify(this.list[0]))
      ConsumerChild({ dataObj: this.dataObjFromList })
      Button('change to self').onClick(() => {
        this.dataObjFromList = this.list[0];
        // 获取原始对象来和新值做对比
        if (UIUtils.getTarget(this.dataObjFromList) !== this.list[0]) {
          this.dataObjFromList = this.list[0];
        } else {
          Log.log(`原始对象DataObj未改变`)
          // 吐司 toast
          promptAction.showToast({ message: "原始对象DataObj未改变" })
        }
      })
    }
  }
}

@Component
struct ConsumerChild {
  @Link @Watch('onDataObjChange') dataObj: DataStatePage;

  onDataObjChange() {
    // TODO 每次点击按钮 都会触发changed监听 (DataObj类型 和 proxy类型不一样)
    // 解决方法1: 给DataObj类添加@Observe注解 将DataObj变为proxy 这样设置的值不会变
    // 解决办法2: 获取原始对象DataObj进行比较 相同则不设置新值
    Log.log("dataObj changed");
    // 吐司 toast
    promptAction.showToast({ message: "dataObj changed" })
  }

  build() {
    Column() {
      Text(this.dataObj.name).fontSize(30)
    }
  }
}

// @Observed
class DataStatePage {
  name: string = 'default name';

  constructor(name: string) {
    this.name = name;
  }
}