import { http } from "@kit.NetworkKit";

export interface IOnRequest {
  handleRequest(reqContext: http.HttpRequestContext): http.HttpRequestContext
}