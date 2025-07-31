import { RouterHelper } from 'static_library_common/src/main/ets/utils/RouterHelper';
import { AbilityHelper } from 'static_library_common/src/main/ets/utils/AbilityHelper';
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
        RouterHelper.startPage(PAGE_SHORT_TASK, {})
      })
      Button('长任务').onClick(() => {
        this.message = '长任务';
        AbilityHelper.startAbility(this.context, "LongTaskAbility", {})
      })
      Button('延迟任务').onClick(() => {
        this.message = '延迟任务';
        RouterHelper.startPage(PAGE_WORK_SCHEDULER, {})
      })
    }
    .height('100%')
    .width('100%')
  }
}