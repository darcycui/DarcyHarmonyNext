import { Log } from 'static_common';
// PersistentStorage要先在Ability中存储 再使通过AppStorage使用
PersistentStorage.persistProp('aProp', 46);
Log.warn('PersistentPage log test')

@Entry
@Component
struct PersistentPage {
  @State message: string = 'Test PersistentStorage';
  @StorageLink('aProp') aProp: number = -1;

  onPageShow(): void {
    let persistentKeys = PersistentStorage.keys()
    Log.log(`persistentKeys: ${persistentKeys}`);
  }

  build() {
    Row() {
      Column({ space: 10 }) {
        Text(this.message)
        // 应用退出时会保存当前结果。重新启动后，会显示上一次的保存结果
        Button(`Click me to save aProp:48`)
          .onClick(() => {
            // 点击赋值48 生效
            AppStorage.setOrCreate('aProp', 48);
          })
        // 应用退出时会保存当前结果。重新启动后，会显示上一次的保存结果
        Button(`Click me to add 1 to aProp:${this.aProp}`) // 初始值46
          .onClick(() => {
            this.aProp += 1;
          })
      }
    }
  }
}