import { buffer, JSON } from '@kit.ArkTS';
import { http } from '@kit.NetworkKit';
import { Log } from 'static_library_common';
import { IPBean, ResultBean } from './models/HttpBean';
import { base64DecodeToString, base64DecodeToUint8Array, base64Encode } from '../utils/Bese64Util';
import { hexToUint8Array, stringToUint8Array, uint8ArrayToHexString } from '../utils/StringUnit8ArrayUtil';
import { generatePubkeyHashBase64 } from './PubkeyPinHelper';

export const BASE_HTTP_URL = "https://apis.juhe.cn"

export const CHECK_IP_PATH = "/ip/ipNewV3"

/**
 * http get请求
 * https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/http-request-V5
 */
export async function doGet<T>(
  httpsUrl: string,
  onSuccess: (data: ResultBean<T>) => void,
  onFailure: (data: string) => void,
  certPath: string = ""
) {
  // 创建http请求
  let httpRequest = http.createHttp()
  // 订阅Response Header事件
  httpRequest.on("headersReceive", (header: object) => {
    Log.warn("header1:" + JSON.stringify(header));
  })
  // base64
  let pubHashInHexJuhe: string = "bd1f92d844aa586bfa4311d079535c99a2632df7613b8055cd2dc682b154d010"
  let pubHashBase64Juhe: string = generatePubkeyHashBase64(pubHashInHexJuhe)
  let pubHashInHexHuawei: string = "060064803b51ac90e3548ba22090d1d7c0fef61ae3c1d5d92a58661e00f28faf"
  let pubHashBase64Huawei: string = generatePubkeyHashBase64(pubHashInHexHuawei)

  // 请求参数
  let requestOptions: http.HttpRequestOptions = {
    // 请求方式
    method: http.RequestMethod.GET,
    // 请求头
    header: { "Content-Type": "application/x-www-form-urlencoded" },
    // 请求参数
    // extraData: { "key": "f128bfc760193c5762c5c3be2a6051d8", "ip": "110.110.110.110" },
    // 期望返回的数据类型
    expectDataType: http.HttpDataType.STRING,
    // 是否使用缓存
    usingCache: false,
    // 请求优先级
    priority: 1,
    connectTimeout: 10_000,
    readTimeout: 10_000,
    // 是否使用代理
    usingProxy: false,
    // 使用的协议
    usingProtocol: http.HttpProtocol.HTTP1_1,
    // 内置证书路径
    caPath: certPath,
    // 证书锁定
    // certificatePinning: [
    //   // {
    //   //   publicKeyHash: pubHashBase64Juhe,
    //   //   hashAlgorithm: 'SHA-256'
    //   // },
    //   {
    //     publicKeyHash: pubHashBase64Huawei,
    //     hashAlgorithm: 'SHA-256'
    //   }
    // ]

  }
  httpRequest.request(
    // 请求地址
    // BASE_HTTP_URL + CHECK_IP_PATH,
    httpsUrl,
    requestOptions,
    (err: Error, data: http.HttpResponse) => {
      if (!err) {
        let message = ""
        // 判断data.result是否是string类型
        if (typeof data.result === 'string') {
          message = data.result
        } else {
          message = JSON.stringify(data.result)
        }
        Log.warn("success message=" + message)
        // 将message解析为对象
        parseBean(message, onSuccess, onFailure);

        Log.warn("code:" + data.responseCode)
        Log.warn("type:" + JSON.stringify(data.resultType))
        Log.warn("header2:" + JSON.stringify(data.header))
        Log.warn("cookies:" + data.cookies)
        Log.warn("Result:" + data.result)
        // 销毁http请求
        httpRequest.destroy()
      } else {
        let error = "Error:" + JSON.stringify(err)
        Log.warn("error message=" + error)
        //parseBean(testJson, onSuccess, onFailure)
        onFailure(error)
        // 取消订阅Response Header事件
        httpRequest.off("headersReceive")
        // 销毁http请求
        httpRequest.destroy()
      }
    }
  )
}

// JSON 字符串
const testJson: string = `{
    "resultcode": "200",
    "reason": "success",
    "result": {
        "Country": "中国",
        "Province": "江苏",
        "City": "苏州",
        "District": "",
        "Isp": "联通"
    },
    "error_code": 0
}`;


function parseBean<T>(message: string, onSuccess: (data: ResultBean<T>) => void, onFailure: (data: string) => void) {
  try {
    let result: ResultBean<T> = JSON.parse(message) as ResultBean<T>;
    // 验证解析结果是否正确
    if (result && result.result && result.result != undefined) {
      Log.log('result format SUCCESS');
      onSuccess(result);
    } else {
      let error = 'result format FAILED'
      Log.error(error);
      onFailure(error)
    }
  } catch (e) {
    Log.error(`Error parsing JSON: ${e}`);
    onFailure(`Error parsing JSON: ${e} \nmessage=${message}`)
  }
}
