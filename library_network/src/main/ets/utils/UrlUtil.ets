export class UrlUtil {

  static stripUrlToPath(url: string): string {
    /*
     * fun stripUrlToPath(url: String): String {
        val afterScheme = url.indexOf("://").let { if (it != -1) url.substring(it + 3) else url }
        val pathStart = afterScheme.indexOf('/')
        return if (pathStart != -1) afterScheme.substring(pathStart) else "/"
    }*/
    // 1. 查找 "://" 并剥离 scheme 部分
    const schemeIndex = url.indexOf("://");
    const afterScheme: string = schemeIndex !== -1
      ? url.substring(schemeIndex + 3)  // 跳过 "://"
      : url;

    // 2. 查找第一个 '/' 作为路径起点
    const pathStart = afterScheme.indexOf('/');

    // 3. 截取路径，若没有 '/' 则返回 "/"
    return pathStart !== -1
      ? afterScheme.substring(pathStart)
      : "/";
  }
}