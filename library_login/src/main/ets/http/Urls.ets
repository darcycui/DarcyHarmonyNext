import { BASE_HTTP_URL } from "library_network"

export class Urls {
  static LOGIN_URL = `${BASE_HTTP_URL}/api/login`
  static LOGOUT_URL = `${BASE_HTTP_URL}/api/logout`
  static REGISTER_URL = `${BASE_HTTP_URL}/api/register`
  static DH_EXCHANGE_URL = `${BASE_HTTP_URL}/api/transport/dh/exchange`

  static SEARCH_FRIEND_URL = `${BASE_HTTP_URL}/api/users/query/phone`
  static APPLY_FRIEND_URL = `${BASE_HTTP_URL}/api/friend-requests/create`
  static QUERY_FRIEND_FROM_URL = `${BASE_HTTP_URL}/api/friend-requests/query/from`
  static QUERY_FRIEND_TO_URL = `${BASE_HTTP_URL}/api/friend-requests/query/to`
  static ACCEPT_FRIEND_URL = `${BASE_HTTP_URL}/api/friend-requests/accept`
  static QUERY_FRIENDSHIP_LIST_URL = `${BASE_HTTP_URL}/api/friendships/query/all`
  static DELETE_FRIENDSHIP_URL = `${BASE_HTTP_URL}/api/friendships/delete`
  static QUERY_CONVERSATION_LIST_URL = `${BASE_HTTP_URL}/api/conversations/query/all`
  static CREATE_CONVERSATION_URL = `${BASE_HTTP_URL}/api/conversations/create`

  static QUERY_PRIVATE_MESSAGE_URL = `${BASE_HTTP_URL}/api/private-messages/query/page`
  static PUSH_X3DH_KEYS_URL = `${BASE_HTTP_URL}/api/x3dh/push/keys`
  static PULL_X3DH_KEYS_URL = `${BASE_HTTP_URL}/api/x3dh/pull/keys`
  static PUSH_ALICE_HELLO_MESSAGE_URL = `${BASE_HTTP_URL}/api/x3dh/push/alice/hello`
  static PULL_ALICE_HELLO_MESSAGE_URL = `${BASE_HTTP_URL}/api/x3dh/pull/alice/hello`

  static RECEIVER_PULL_OFFLINE_MESSAGE_URL = `${BASE_HTTP_URL}/api/message/read/receiver/pull/offline`
  static RECEIVER_PUSH_MESSAGE_READ_STATUS_URL = `${BASE_HTTP_URL}/api/message/read/receiver/push/read`
  static SENDER_SYNC_MESSAGE_READ_STATUS_URL = `${BASE_HTTP_URL}/api/message/read/sender/sync/offline`
}
