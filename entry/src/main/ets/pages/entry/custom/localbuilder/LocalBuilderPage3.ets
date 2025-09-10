import { Log } from 'static_library_common';

class DataBuilderPage {
  size: number = 0;
}

@Entry
@Component
struct LocalBuilderPage3 {
  label: string = 'parent';
  @State data: DataBuilderPage = new DataBuilderPage();

  // @Builder 不绑定父组件  在子组件中使用, this-->child
  @Builder
  componentBuilder($$: DataBuilderPage) {
    Text(`builder + $$`)
    Text(`${'this -> ' + this.label}`) // this -> child
    Text(`${'size : ' + $$.size}`) // TODO Builder $$.size 这里的size UI会刷新
    Text(`------------------------`)
  }

  // @LocalBuilder 将函数绑定到父组件 在子组件中使用, this-->parent
  @LocalBuilder
  componentLocalBuilder($$: DataBuilderPage) {
    Text(`LocalBuilder + $$ data`)
    Text(`${'this -> ' + this.label}`) // this -> parent
    Text(`${'size : ' + $$.size}`)// TODO LocalBuilder $$.size 这里的size UI不刷新 刷新范围是当前组件及其子组件 不包括父组件
      .fontColor(Color.Red)
    Text(`------------------------`)
  }

  @LocalBuilder
  contentLocalBuilderNoArgument() {
    Text(`LocalBuilder + local data`)
    Text(`${'this -> ' + this.label}`) // this -> parent
    Text(`${'size : ' + this.data.size}`) // this.data.size 这里的size UI会刷新
    Text(`------------------------`)
  }

  build() {
    Column({ space: 10 }) {
      Child({
        // @builder直接传参 TODO this->child 会刷新
        contentBuilder: this.componentBuilder,
        // @builder使用箭头函数 包一层传参 TODO this->parent 不会刷新
        contentBuilderArrow: (data: DataBuilderPage): void => {
          this.componentBuilder(data)
        },
        // @localbuilder 带参数 TODO this->parent 不会刷新
        contentLocalBuilder: this.componentLocalBuilder,
        // @localbuilder 不带参数 TODO this->parent 会刷新
        contentLocalBuilderNoArgument: this.contentLocalBuilderNoArgument,
        data: this.data
      })
      Text(`${'父组件 size : ' + this.data.size}`)
      Button('父组件修改size: +100').width('100%').onClick(() => {
        this.data.size += 100;
        Log.log(`1--size=${this.data.size}`)
      }
      )
    }
  }
}

@Component
struct Child {
  label: string = 'child';

  @Builder
  customBuilder() {
  };

  // @BuilderParam @Builder类型的参数
  @BuilderParam contentBuilder: ((data: DataBuilderPage) => void) = this.customBuilder;
  @BuilderParam contentBuilderArrow: ((data: DataBuilderPage) => void) = this.customBuilder;
  @BuilderParam contentLocalBuilder: ((data: DataBuilderPage) => void) = this.customBuilder;
  @BuilderParam contentLocalBuilderNoArgument: (() => void) = this.customBuilder;
  @Link data: DataBuilderPage;

  build() {
    Column() {
      this.contentBuilder({ size: this.data.size })
      this.contentBuilderArrow({ size: this.data.size })
      this.contentLocalBuilder({ size: this.data.size })
      this.contentLocalBuilderNoArgument()
      Text(`${'子组件 size : ' + this.data.size}`)
      Button("子组件修改size: +1").width('100%').onClick(() => {
        this.data.size += 1;
        Log.log(`2--size=${this.data.size}`)
      })
    }
  }
}