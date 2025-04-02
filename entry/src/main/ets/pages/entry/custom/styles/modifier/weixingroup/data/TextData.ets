export class TextData {
  private _color?: Color | undefined;
  public instance?: TextAttribute

  constructor(color: Color | undefined) {
    this._color = color;
  }


  public set color(value: Color | undefined) {
    this._color = value;
    this.instance?.fontColor(value)
  }

  public get color(): Color | undefined {
    return this._color;
  }

}