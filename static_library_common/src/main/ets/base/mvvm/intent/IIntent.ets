/**
 * BaseIntent - MVI Intent 基类
 *
 * 所有页面的 Intent 子类应继承此类，以便 dispatch 方法通过 instanceof 进行分支判断。
 *
 * ─── 使用示例 ───────────────────────────────────
 * ```typescript
 * export class LoadTasksIntent extends BaseIntent {
 *   readonly thingsName: string = '';
 *   constructor(thingsName?: string) {
 *     super();
 *     if (thingsName !== undefined) {
 *       this.thingsName = thingsName;
 *     }
 *   }
 * }
 * ```
 */
export interface IIntent {
}
