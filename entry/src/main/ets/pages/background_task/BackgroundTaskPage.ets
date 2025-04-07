import { startAbility, startPage } from '../../utils/RouterHelper';
import { PAGE_LONG_TASK, PAGE_SHORT_TASK, PAGE_WORK_SCHEDULER } from '../PageName';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct BackgroundTaskPage {
  @State message: string = 'Test BackgroundTask';
  context = getContext(this) as common.UIAbilityContext;

  build() {
    Column({ space: 20 }) {
      Text(this.message)
      Button('短任务').onClick(() => {
        this.message = '短任务';
        startPage(PAGE_SHORT_TASK, {})
      })
      Button('长任务').onClick(() => {
        this.message = '长任务';
        startAbility(this.context, "LongTaskAbility", {})
      })
      Button('延迟任务').onClick(() => {
        this.message = '延迟任务';
        startPage(PAGE_WORK_SCHEDULER, {})
      })
    }
    .height('100%')
    .width('100%')
  }
}