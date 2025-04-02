import { TextData } from "../data/TextData";
import { AttributeUpdater } from "@kit.ArkUI";


export class WeiXinGroupTextAttributeUpdater extends AttributeUpdater<TextAttribute, TextInterface> {
  data?: TextData

  constructor() {
    super();
  }

  updateData(data: TextData): WeiXinGroupTextAttributeUpdater {
    this.data = data
    this.setUpdateFunc(this.data, this.attribute)
    this.applyAttribute(this.data, this.attribute)
    return this
  }

  applyAttribute(data: TextData, instance: TextAttribute| undefined) {
    if (data.color || data.color == undefined) {
      instance?.fontColor(data?.color)
    }
  }

  setUpdateFunc(data: TextData, instance: TextAttribute | undefined) {
    data.instance = instance
  }
}