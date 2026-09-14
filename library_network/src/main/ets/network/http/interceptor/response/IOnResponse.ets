import { http } from "@kit.NetworkKit";

export interface IOnResponse {
  handleResponse(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): http.HttpResponse
}