import { workScheduler, WorkSchedulerExtensionAbility } from "@kit.BackgroundTasksKit";
import { Log } from "static_common";

export class EntryWorkSchedulerExtensionAbility extends WorkSchedulerExtensionAbility{
  onWorkStart(work: workScheduler.WorkInfo): void {
    Log.log(`EntryWorkSchedulerExtensionAbility onWorkStart work=${JSON.stringify(work)}`)
  }
  onWorkStop(work: workScheduler.WorkInfo): void {
    Log.log(`EntryWorkSchedulerExtensionAbility onWorkStop work=${JSON.stringify(work)}`)
  }
}