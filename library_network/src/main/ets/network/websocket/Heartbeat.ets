import { webSocket } from "@kit.NetworkKit"
import { Log } from "static_library_common"

let TAG = "[Heartbeat] "

let pingInterval = -1
let pongTimeout = -1
const PING_INTERVAL: number = 10_000
const PONG_TIMEOUT: number = 5_000

export function startHeartbeat(websocket: webSocket.WebSocket) {
  pingInterval = setInterval(() => {
    Log.log('客户端发送心跳: ping...')
    websocket.send("ping")
    clearPongTimeout()
    pongTimeout = setTimeout(() => {
      Log.error('客户端发送心跳超时: pong timeout...')
      websocket.close()
    }, PONG_TIMEOUT)
  }, PING_INTERVAL)
}


export function clearPongTimeout() {
  clearTimeout(pongTimeout);
}

export function clearPingInterval() {
  clearInterval(pingInterval);
}

export function stopHeartbeat() {
  clearPingInterval()
  clearPongTimeout()
}