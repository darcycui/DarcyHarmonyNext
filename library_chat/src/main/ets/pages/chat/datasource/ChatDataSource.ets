import { BasicDataSource } from "static_library_common";
import { ChatItem } from "../../../models/ChatItem";

export class ChatDataSource extends BasicDataSource<ChatItem> {
  public pushData(item: ChatItem): void {
    this.dataArray.push(item);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}
