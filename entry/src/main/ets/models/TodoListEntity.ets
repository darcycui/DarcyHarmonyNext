
import { common } from '@kit.AbilityKit';
import util from '@ohos.util';
import { Log } from 'static_library_common';
import ThingsEntity from './ThingsEntity';

export default class TodoListEntity {
  things: Array<ThingsEntity> = [];

  constructor(things: Array<ThingsEntity>) {
    this.things = things;
  }

  async loadTasks(context: common.UIAbilityContext) {
    Log.log(`loadTasks start+++`)
    // 等待2秒
    await new Promise<void>(resolve => setTimeout(resolve, 2000));
    let getJson = await context.resourceManager.getRawFileContent('defaultTasks.json');
    let textDecoderOptions: util.TextDecoderOptions = { ignoreBOM: true };
    let textDecoder = util.TextDecoder.create('utf-8', textDecoderOptions);
    let result = textDecoder.decodeToString(getJson, { stream: false });
    Log.log(`loadTasks end---`)
    this.things = JSON.parse(result);
  }
}