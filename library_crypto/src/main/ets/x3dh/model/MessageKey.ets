/**
 * 消息密钥模型
 *
 * Double Ratchet 协议中推导出的消息加密密钥集合
 * 用于替代 Kotlin 的 Pair/ Triple 返回值
 */
export class MessageKey {
  /** 发送方用户 ID */
  fromUserId: number = 0;

  /** 接收方用户 ID */
  toUserId: number = 0;

  /** DH 公钥（hex 字符串） */
  dhPublicKey: string = '';

  /** 消息加密密钥（hex 字符串） */
  messageKey: string = '';

  /** MAC 密钥（hex 字符串） */
  macKey: string = '';

  /** 初始化向量（hex 字符串） */
  iv: string = '';

  /** 发送链消息序号 */
  nKey: number = 0;

  /** 前一个发送链长度 */
  pnKey: number = 0;

  /** 路由路径 */
  url: string = '';

  private static readonly FROM_USER_ID: string = 'fromUserId';
  private static readonly TO_USER_ID: string = 'toUserId';
  private static readonly DH_PUBLIC_KEY: string = 'dhPublicKey';
  private static readonly URL: string = 'url';
  private static readonly N_KEY: string = 'N_KEY';
  private static readonly PN_KEY: string = 'PN_KEY';

  constructor(
    fromUserId?: number,
    toUserId?: number,
    dhPublicKey?: string,
    messageKey?: string,
    macKey?: string,
    iv?: string,
    nKey?: number,
    pnKey?: number,
    url?: string,
  ) {
    if (fromUserId !== undefined) this.fromUserId = fromUserId;
    if (toUserId !== undefined) this.toUserId = toUserId;
    if (dhPublicKey !== undefined) this.dhPublicKey = dhPublicKey;
    if (messageKey !== undefined) this.messageKey = messageKey;
    if (macKey !== undefined) this.macKey = macKey;
    if (iv !== undefined) this.iv = iv;
    if (nKey !== undefined) this.nKey = nKey;
    if (pnKey !== undefined) this.pnKey = pnKey;
    if (url !== undefined) this.url = url;
  }

  static fromMap(map: Map<string, string>): MessageKey {
    return new MessageKey(
      Number(map.get(MessageKey.FROM_USER_ID)) || 0,
      Number(map.get(MessageKey.TO_USER_ID)) || 0,
      map.get(MessageKey.DH_PUBLIC_KEY) ?? '',
      undefined,
      undefined,
      undefined,
      Number(map.get(MessageKey.N_KEY)) || 0,
      Number(map.get(MessageKey.PN_KEY)) || 0,
      map.get(MessageKey.URL) ?? '',
    );
  }

  toMap(): Map<string, string> {
    const map = new Map<string, string>();
    map.set(MessageKey.FROM_USER_ID, this.fromUserId.toString());
    map.set(MessageKey.TO_USER_ID, this.toUserId.toString());
    map.set(MessageKey.DH_PUBLIC_KEY, this.dhPublicKey);
    map.set(MessageKey.N_KEY, this.nKey.toString());
    map.set(MessageKey.PN_KEY, this.pnKey.toString());
    map.set(MessageKey.URL, this.url);
    return map;
  }
}
