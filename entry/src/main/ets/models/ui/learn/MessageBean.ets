export class MessageBean {
  private from: string = "";
  private to: string = "";
  private message: string = "";
  private createTime: number = 0;

  constructor();

  constructor(from: string, to: string, message: string, createTime: number);

  constructor(from: string = "", to: string = "", message: string = "", createTime: number = 0) {
    this.from = from;
    this.to = to;
    this.message = message;
    this.createTime = createTime;
  }
}