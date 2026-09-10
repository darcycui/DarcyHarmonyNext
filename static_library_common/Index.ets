// TODO 导出组件 在Index.ets导出文件中声明
export { StaticMainPage } from './src/main/ets/components/StaticMainPage'

export { StaticInnerPage } from './src/main/ets/pages/StaticInnerPage'

// TODO 导出类 在Index.ets导出文件中声明
export { Log } from './src/main/ets/utils/Log'

export { InitCommon } from './src/main/ets/InitCommon'

export { HiLog } from './src/main/ets/utils/HiLog'

export { RouterHelper } from './src/main/ets/utils/RouterHelper'

export { NavigationUtil as NavigationHelper } from './src/main/ets/utils/NavigationUtil'

export { AbilityUtil as AbilityHelper } from './src/main/ets/utils/AbilityUtil'

export { ToastUtil } from './src/main/ets/utils/ToastUtil'

export { BasicDataSource } from './src/main/ets/datasource/BasicDataSource'

export { BaseUIAbility } from './src/main/ets/base/BaseUIAbility'

export { Contexts } from './src/main/ets/utils/Contexts'

// TODO 导出函数 在Index.ets导出文件中声明
export { func, func2 } from './src/main/ets/utils/Log'

/**
 * base 模块统一导出入口
 *
 * 使用方式：
 * ```typescript
 * import { BaseViewModel, BaseIntent } from '../base';
 * import { BaseUseCase } from '../base';
 * import { BaseRepository } from '../base';
 * ```
 */
export { BaseViewModel } from './src/main/ets/base/mvvm/BaseViewModel';
export { BaseIntent } from './src/main/ets/base/mvvm/BaseIntent';
export { BaseUseCase, BaseNoParamUseCase } from './src/main/ets/base/mvvm/BaseUseCase';
export { BaseRepository } from './src/main/ets/base/mvvm/BaseRepository';

