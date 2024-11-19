import { Log } from "static_common"
import { webSocket } from "@kit.NetworkKit"
import { BusinessError } from "@kit.BasicServicesKit"
import { MessageBean } from "../bean/MessageBean"

export const self = "Harmony"

export const other = "three-to-harmony"

// export const other = "user_two"

// export const WSS_URL = "ws://10.0.0.126:7777/person/" + self
export const WSS_URL = "wss://10.0.0.126:8443/person/" + self

let ws: webSocket.WebSocket

export function connectWS(
  wssUrl: string,
  certPath: string,
  onOpen: () => void,
  onMessage: (data: string | ArrayBuffer) => void,
  onClose: () => void,
  onError: (message: string) => void) {
  // 创建websocket对象
  ws = webSocket.createWebSocket()
  ws.on("open", (err: BusinessError, value: object) => {
    Log.warn("on open:" + JSON.stringify(value))
    onOpen()
    // 发送消息
    if (value) {
      sendWS("hello", self, self)
    } else {
      Log.warn("value is null")
    }
  })
  // 接收消息
  ws.on("message", (err: BusinessError, value: string | ArrayBuffer) => {
    Log.warn("on message:" + value)
    onMessage(value)
  })
  // 关闭事件
  ws.on("close", (err: BusinessError, value: object) => {
    Log.warn("on close:" + JSON.stringify(value))
    onClose()
  })
  // 错误事件
  ws.on("error", (err: BusinessError) => {
    let errMsg = "on error:" + err.message + JSON.stringify(err)
    Log.warn(errMsg)
    onError(errMsg)
  })
  // 设置websocket参数
  let requestOptions: webSocket.WebSocketRequestOptions = {
    header: { "key1": "value1" },
    // 内置证书路径
    // caPath: certPath,
    clientCert: {
      certPath: "",
      keyPath: "",
      keyPassword: ""
    }
  }
  // 连接
  ws.connect(wssUrl,
    requestOptions,
    (err: BusinessError, value: boolean) => {
      if (!err && value) {
        Log.warn("connect success")
      } else {
        Log.warn("connect failed")
      }
    })
}

// 发送消息
export function sendWS(message: string, from: string, to: string) {
  let messageBean = new MessageBean(
    from,
    to,
    message,
    Date.now())
  let messageStr = JSON.stringify(messageBean)
  ws.send(messageStr, (err: BusinessError, value: boolean) => {
    if (!err) {
      Log.warn("send hello success")
    } else {
      Log.warn("send hello failed")
    }
  })
}

export function closeWS() {
  ws.close().then(result => {
    Log.warn(`close status:${result}`)
  }).catch(() => {
    Log.warn(`close error:`)
  })
}
