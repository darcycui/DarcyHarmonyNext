
export class ItemBean {
  private _pageName: string;

  public set pageName(value: string) {
    this._pageName = value;
  }

  public get pageName(): string {
    return this._pageName;
  }

  private _text: Resource;

  public set text(value: Resource) {
    this._text = value;
  }

  public get text(): Resource {
    return this._text;
  }

  constructor(pageName: string, text: Resource) {
    this._pageName = pageName
    this._text = text
  }
}