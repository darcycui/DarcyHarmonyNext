// ============================================================
// library_network 导出声明
// 鸿蒙Next静态库(HAR) - 网络请求封装库
// ============================================================

// ---------- HTTP ----------
export { BASE_HTTP_URL, CHECK_IP_PATH, doGet, doPost } from './src/main/ets/network/http/HttpHelper'
export { generatePubkeyHashBase64 } from './src/main/ets/network/http/ssl/PubkeyPinHelper'

// ---------- Models (基础) ----------
export { HttpErrorEntity } from './src/main/ets/network/models/HttpErrorEntity'
export { HttpResultEntity } from './src/main/ets/network/models/HttpResultEntity'

// ---------- Models (Request DTO) ----------
export { CommonRequestDTO } from './src/main/ets/network/models/request/CommonRequestDTO'
export { ConversationCreateRequestDTO } from './src/main/ets/network/models/request/ConversationCreateRequestDTO'
export { ConversationQueryRequestDTO } from './src/main/ets/network/models/request/ConversationQueryRequestDTO'
export { DHExchangeRequestDTO } from './src/main/ets/network/models/request/DHExchangeRequestDTO'
export { FriendRequestActionRequestDTO } from './src/main/ets/network/models/request/FriendRequestActionRequestDTO'
export { FriendRequestCreateRequestDTO } from './src/main/ets/network/models/request/FriendRequestCreateRequestDTO'
export { FriendRequestQueryFromRequestDTO } from './src/main/ets/network/models/request/FriendRequestQueryFromRequestDTO'
export { FriendRequestQueryToRequestDTO } from './src/main/ets/network/models/request/FriendRequestQueryToRequestDTO'
export { FriendshipDeleteRequestDTO } from './src/main/ets/network/models/request/FriendshipDeleteRequestDTO'
export { FriendshipUpdateRequestDTO } from './src/main/ets/network/models/request/FriendshipUpdateRequestDTO'
export { LoginRequestDTO } from './src/main/ets/network/models/request/LoginRequestDTO'
export { MessageReadStatusRequest } from './src/main/ets/network/models/request/MessageReadStatusRequest'
export { OneTimePreKeyInputDTO } from './src/main/ets/network/models/request/OneTimePreKeyInputDTO'
export { PrivateMessageQueryRequestDTO } from './src/main/ets/network/models/request/PrivateMessageQueryRequestDTO'
export { PrivateMessageSendRequestDTO } from './src/main/ets/network/models/request/PrivateMessageSendRequestDTO'
export { ReceiverMessageReadStatusMarkRequestDTO } from './src/main/ets/network/models/request/ReceiverMessageReadStatusMarkRequestDTO'
export { RegisterRequestDTO } from './src/main/ets/network/models/request/RegisterRequestDTO'
export { X3DHPullHelloRequestDTO } from './src/main/ets/network/models/request/X3DHPullHelloRequestDTO'
export { X3DHPullKeysRequestDTO } from './src/main/ets/network/models/request/X3DHPullKeysRequestDTO'
export { X3DHPushHelloRequestDTO } from './src/main/ets/network/models/request/X3DHPushHelloRequestDTO'
export { X3DHPushKeysRequestDTO } from './src/main/ets/network/models/request/X3DHPushKeysRequestDTO'

// ---------- Models (Response Entity) ----------
export { ApplyFriendResponse } from './src/main/ets/network/models/response/ApplyFriendResponse'
export { ConversationResponse } from './src/main/ets/network/models/response/ConversationResponse'
export { DHExchangeResponse } from './src/main/ets/network/models/response/DHExchangeResponse'
export { FriendshipResponse } from './src/main/ets/network/models/response/FriendshipResponse'
export { LoginResponse } from './src/main/ets/network/models/response/LoginResponse'
export { MessageReadStatusResponse } from './src/main/ets/network/models/response/MessageReadStatusResponse'
export { Pageable } from './src/main/ets/network/models/response/Pageable'
export { PrivateMessageResponse } from './src/main/ets/network/models/response/PrivateMessageResponse'
export { PrivateMessageResponsePage } from './src/main/ets/network/models/response/PrivateMessageResponsePage'
export { RegisterResponse } from './src/main/ets/network/models/response/RegisterResponse'
export { Sort } from './src/main/ets/network/models/response/Sort'
export { UserResponse } from './src/main/ets/network/models/response/UserResponse'
export { X3DHAliceHelloPullResponse } from './src/main/ets/network/models/response/X3DHAliceHelloPullResponse'
export { X3DHAliceHelloPushResponse } from './src/main/ets/network/models/response/X3DHAliceHelloPushResponse'
export { X3DHKeysPullResponse } from './src/main/ets/network/models/response/X3DHKeysPullResponse'
export { X3DHKeysPushResponse } from './src/main/ets/network/models/response/X3DHKeysPushResponse'

// ---------- Parser ----------
export { parseResultBean } from './src/main/ets/network/parser/JsonParser'

// ---------- WebSocket ----------
export { self, other, WSS_URL, connectWS, sendWS, closeWS } from './src/main/ets/network/websocket/WebSocket'
export { startHeartbeat, stopHeartbeat } from './src/main/ets/network/websocket/Heartbeat'

// ---------- Utils ----------
export { base64DecodeToString, base64DecodeToUint8Array, base64Encode } from './src/main/ets/utils/Bese64Util'
export { hexToUint8Array, uint8ArrayToHexString, stringToUint8Array, uint8ArrayToString } from './src/main/ets/utils/StringUnit8ArrayUtil'

// ---------- Models ----------
export { MessageBean } from './src/main/ets/models/MessageBean'
