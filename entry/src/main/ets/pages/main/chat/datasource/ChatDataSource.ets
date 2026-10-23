import { BasicDataSource } from "static_library_common";
import { ChatItem } from "../../../../models/ui/im/ChatItem";

export class ChatDataSource extends BasicDataSource<ChatItem> {
  public pushData(item: ChatItem): void {
    this.dataArray.push(item);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public reloadData(items: ChatItem[]): void {
    this.dataArray = items.slice();
    this.notifyDataReload();
  }
}
