import { JSON } from '@kit.ArkTS';
import { http } from '@kit.NetworkKit';
import { Log } from 'static_library_common';
import { HttpErrorEntity } from '../models/HttpErrorEntity';
import { HttpResultEntity } from '../models/HttpResultEntity';
import { parseResultBean as parseResultBean } from '../parser/JsonParser';
import { generatePubkeyHashBase64 } from './ssl/PubkeyPinHelper';

export const BASE_HTTP_URL = "https://apis.juhe.cn"

export const CHECK_IP_PATH = "/ip/ipNewV3"

/**
 * http get请求
 * https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/http-request-V5
 */
export async function doGet<T>(
  httpsUrl: string,
  onSuccess: (data: HttpResultEntity<T>) => void,
  onFailure: (data: HttpErrorEntity) => void,
  certPath: string = ""
) {
  Log.log(`request ==> doGet: ${httpsUrl}`)
  // 创建http请求
  let httpRequest = http.createHttp()
  // 订阅Response Header事件
  httpRequest.on("headersReceive", (header: object) => {
    Log.warn("header1:" + JSON.stringify(header));
  })
  // base64
  let pubHashInHexJuhe: string = "bd1f92d844aa586bfa4311d079535c99a2632df7613b8055cd2dc682b154d010"
  let pubHashBase64Juhe: string = generatePubkeyHashBase64(pubHashInHexJuhe)

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
    //   {
    //     publicKeyHash: pubHashBase64Juhe,
    //     hashAlgorithm: 'SHA-256'
    //   }
    // ]
  }
  httpRequest.request(
    // 请求地址
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
        Log.warn("response <== " + message)
        Log.warn("code:" + data.responseCode)
        Log.warn("type:" + JSON.stringify(data.resultType))
        Log.warn("header2:" + JSON.stringify(data.header))
        Log.warn("cookies:" + data.cookies)
        Log.warn("Result:" + data.result)
        // 将message解析为对象
        parseResultBean(message, onSuccess, onFailure)
        // 销毁http请求
        httpRequest.destroy()
      } else {
        let error = "Error:" + JSON.stringify(err)
        Log.warn("error message=" + error)
        //parseBean(testJson, onSuccess, onFailure)
        onFailure(new HttpErrorEntity({
          message: error,
          status: -1,
        }))
        // 取消订阅Response Header事件
        httpRequest.off("headersReceive")
        // 销毁http请求
        httpRequest.destroy()
      }
    }
  )
}

/**
 * http post请求——JSON 请求体
 * 结构参考 doGet，请求方式为 POST，body 以 JSON 字符串形式放入请求体
 */
export async function doPost<T>(
  httpsUrl: string,
  body: string,
  onSuccess: (data: HttpResultEntity<T>) => void,
  onFailure: (data: HttpErrorEntity) => void,
  certPath: string = ""
) {
  Log.log(`request ==> doPost: ${httpsUrl}`)
  Log.log(`body: ${body}`)
  // 创建http请求
  let httpRequest = http.createHttp()
  // 订阅Response Header事件
  httpRequest.on("headersReceive", (header: object) => {
    Log.warn("header1:" + JSON.stringify(header))
  })

  // 请求参数
  let requestOptions: http.HttpRequestOptions = {
    // 请求方式
    method: http.RequestMethod.POST,
    // 请求头——JSON 请求体
    header: { "Content-Type": "application/json" },
    // 请求体（调用方用 JSON.stringify 序列化业务对象后传入）
    extraData: body,
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
  }
  httpRequest.request(
    // 请求地址
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
        Log.warn("response <== " + message)
        Log.warn("code:" + data.responseCode)
        Log.warn("type:" + JSON.stringify(data.resultType))
        Log.warn("header2:" + JSON.stringify(data.header))
        Log.warn("cookies:" + data.cookies)
        Log.warn("Result:" + data.result)
        // 将message解析为对象
        parseResultBean(message, onSuccess, onFailure)
        // 销毁http请求
        httpRequest.destroy()
      } else {
        let error = "Error:" + JSON.stringify(err)
        Log.warn("error message=" + error)
        onFailure(new HttpErrorEntity({
          message: error,
          status: -1,
        }))
        // 取消订阅Response Header事件
        httpRequest.off("headersReceive")
        // 销毁http请求
        httpRequest.destroy()
      }
    }
  )
}

