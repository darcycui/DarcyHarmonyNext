// ============================================================
// library_crypto 导出声明
// 鸿蒙Next静态库(HAR) - 加解密工具库
// ============================================================

// ---------- 加解密工具 ----------
export { TransportCipherUtil } from './src/main/ets/utils/TransportCipherUtil'

export { MessageCipher } from './src/main/ets/utils/MessageCipher'

// ---------- DH 密钥交换工具 ----------
export { ECCExchangeUtil } from './src/main/ets/utils/ECCExchangeUtil'

export { ServerDHSecretManager } from './src/main/ets/storage/memory/ServerDHSecretManager'

export { AADs } from './src/main/ets/aead/AADs'

// ---------- X3DH / Double Ratchet 工具 ----------

export { HKDF1 } from './src/main/ets//x3dh/chain/HKDF1'

export { EncryptUtil } from './src/main/ets/utils/EncryptUtil'

export { ChainKey } from './src/main/ets/x3dh/chain/ChainKey'

export { KeyUtil } from './src/main/ets/utils/KeyUtil'
