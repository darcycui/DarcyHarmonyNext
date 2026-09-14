import { http } from "@kit.NetworkKit";

export interface IOnRequest {
  handleRequest(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): void
}