import { HttpHelper } from '../../http/HttpHelper'

export class Websockets {
  static WEBSOCKET_URL_LOCAL = `ws://${HttpHelper.BASE_HTTP_URL}/stomp-ws`
  static WEBSOCKET_URL_WSS_SERVER = `wss://${HttpHelper.BASE_HTTP_URL}/stomp-ws`
  static WEBSOCKET_URL_WSS = Websockets.WEBSOCKET_URL_LOCAL
  // const WEBSOCKET_URL_WSS = Websockets.WEBSOCKET_URL_WSS_SERVER
}
