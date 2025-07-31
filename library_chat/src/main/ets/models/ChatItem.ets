@Observed
export class ChatItem {
  public isSelf(): boolean {
    return this.id === 101;
  }

  private _id: number;

  public set id(value: number) {
    this._id = value;
  }

  public get id(): number {
    return this._id;
  }

  private _from: string;

  public set from(value: string) {
    this._from = value;
  }

  public get from(): string {
    return this._from;
  }

  private _message: string;

  public set message(value: string) {
    this._message = value;
  }

  public get message(): string {
    return this._message;
  }

  private _time: string;

  public set time(value: string) {
    this._time = value;
  }

  public get time(): string {
    return this._time;
  }

  constructor(id: number, from: string, message: string) {
    this._id = id;
    this._from = from;
    this._message = message;
    this._time = new Date().toLocaleTimeString();
  }
}
