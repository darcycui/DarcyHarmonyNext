import { JSON } from '@kit.ArkTS';
import { http } from '@kit.NetworkKit';
import { Base64Util, HexUtil, Log } from 'static_library_common';
import { HttpErrorEntity } from '../models/HttpErrorEntity';
import { HttpResultEntity } from '../models/HttpResultEntity';
import { JsonParser } from '../parser/JsonParser';
import { HttpCertHelper } from './ssl/HttpCertHelper';
import { Available } from '@kit.BasicServicesKit';
import { HttpInterceptorManager } from './interceptor/HttpInterceptorManager';

@Available({ minApiVersion: 'OpenHarmony 22' })
export class HttpHelper {
  private static readonly BASE_HTTP_URL_TEST: string = "http://192.168.0.110:7443"
  private static readonly BASE_HTTP_URL_RELEASE: string = "https://darcycui.com.cn"
  static readonly BASE_HTTP_URL: string = HttpHelper.BASE_HTTP_URL_TEST
  // static readonly BASE_HTTP_URL: string = HttpHelper.BASE_HTTP_URL_RELEASE

  private static readonly interceptorChain = HttpInterceptorManager.createDefaultInterceptorChain();

  /**
   * http get请求
   * https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/http-request-V5
   */
  static async doGet<T>(
    httpsUrl: string,
    onSuccess: (data: HttpResultEntity<T>) => void,
    onFailure: (data: HttpResultEntity<HttpErrorEntity>) => void,
    certPath: string = HttpCertHelper.getCertPath()
  ) {
    Log.log(`request ==> doGet: ${httpsUrl}`)
    let httpRequest = http.createHttp()

    HttpHelper.interceptorChain.apply(httpRequest);

    httpRequest.on("headersReceive", (header: object) => {
      // Log.warn("request header ==>" + JSON.stringify(header));
    })

    let pubHashInHexJuhe: string = "bd1f92d844aa586bfa4311d079535c99a2632df7613b8055cd2dc682b154d010"
    let pubHashBase64Juhe: string = Base64Util.base64Encode(HexUtil.hexToBytes(pubHashInHexJuhe))

    let requestOptions: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
      header: { "Content-Type": "application/x-www-form-urlencoded" },
      expectDataType: http.HttpDataType.STRING,
      usingCache: false,
      priority: 1,
      connectTimeout: 10_000,
      readTimeout: 10_000,
      usingProxy: false,
      usingProtocol: http.HttpProtocol.HTTP1_1,
      caPath: certPath,
      // certificatePinning: [
      //   {
      //     publicKeyHash: pubHashBase64Juhe,
      //     hashAlgorithm: 'SHA-256'
      //   }
      // ]
    }
    httpRequest.request(
      httpsUrl,
      requestOptions,
      (err: Error, data: http.HttpResponse) => {
        if (!err) {
          let message = ""
          if (typeof data.result === 'string') {
            message = data.result
          } else {
            message = JSON.stringify(data.result)
          }
          // Log.warn("response header <==" + JSON.stringify(data.header))
          // Log.warn("response <== " + message)
          // Log.warn("Result:" + data.result)
          JsonParser.parseResultBean(message, onSuccess, onFailure)
          httpRequest.destroy()
        } else {
          let errorMessage = "Error:" + JSON.stringify(err)
          Log.warn("error message=" + errorMessage)
          onFailure(new HttpResultEntity<HttpErrorEntity>(
            -3, new HttpErrorEntity({
            message: errorMessage,
            status: -3,
          })))
          httpRequest.off("headersReceive")
          httpRequest.destroy()
        }
      }
    )
  }

  /**
   * http post请求——JSON 请求体
   * 结构参考 doGet，请求方式为 POST，body 以 JSON 字符串形式放入请求体
   */
  static async doPost<T>(
    httpsUrl: string,
    body: string,
    onSuccess: (data: HttpResultEntity<T>) => void,
    onFailure: (data: HttpResultEntity<HttpErrorEntity>) => void,
    certPath: string = HttpCertHelper.getCertPath()
  ) {
    Log.log(`request ==> doPost: ${httpsUrl}`)
    Log.log(`body: ${body}`)
    let httpRequest = http.createHttp()

    HttpHelper.interceptorChain.apply(httpRequest);

    httpRequest.on("headersReceive", (header: object) => {
      // Log.warn("request header:" + JSON.stringify(header))
    })

    let requestOptions: http.HttpRequestOptions = {
      method: http.RequestMethod.POST,
      header: { "Content-Type": "application/json" },
      extraData: body,
      expectDataType: http.HttpDataType.STRING,
      usingCache: false,
      priority: 1,
      connectTimeout: 10_000,
      readTimeout: 10_000,
      usingProxy: false,
      usingProtocol: http.HttpProtocol.HTTP1_1,
      caPath: certPath,
    }
    httpRequest.request(
      httpsUrl,
      requestOptions,
      (err: Error, data: http.HttpResponse) => {
        if (!err) {
          let message = ""
          if (typeof data.result === 'string') {
            message = data.result
          } else {
            message = JSON.stringify(data.result)
          }
          // Log.warn("response header <==" + JSON.stringify(data.header))
          // Log.warn("response <== " + message)
          // Log.warn("Result:" + data.result)
          JsonParser.parseResultBean(message, onSuccess, onFailure)
          httpRequest.destroy()
        } else {
          let errorMessage = "Error:" + JSON.stringify(err)
          Log.warn("error message=" + errorMessage)
          onFailure(new HttpResultEntity<HttpErrorEntity>(
            -1, new HttpErrorEntity({
            message: errorMessage,
            status: -1,
          })))
          httpRequest.off("headersReceive")
          httpRequest.destroy()
        }
      }
    )
  }
}
