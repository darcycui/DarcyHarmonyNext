/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { common } from '@kit.AbilityKit';

export class GlobalCameraContext {
  private static instance: GlobalCameraContext;
  private _objects = new Map<string, Object>();
  private cameraSettingContext: common.UIAbilityContext | undefined = undefined;

  public static getInstance(): GlobalCameraContext {
    if (!Boolean(GlobalCameraContext.instance).valueOf()) {
      GlobalCameraContext.instance = new GlobalCameraContext();
    }
    return GlobalCameraContext.instance;
  }

  getT<T>(value: string): T {
    return this._objects.get(value) as T;
  }

  setObject(key: string, objectClass: Object): void {
    this._objects.set(key, objectClass);
  }

  apply(value: string): void {
    const func = this._objects.get(value);
    if (func) {
      (func as Function)();
    }
  }

  public setCameraSettingContext(context: common.UIAbilityContext): void {
    this.cameraSettingContext = context;
  }

  public getCameraSettingContext(): common.UIAbilityContext | undefined {
    return this.cameraSettingContext;
  }
}