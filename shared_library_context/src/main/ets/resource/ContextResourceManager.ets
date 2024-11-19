/**
 * Resource Manager
 * TODO 通过静态方法导出资源(图片,字符串等)
 */
export class ContextResourceManager {
  static getIcon(): Resource {
    return $r("app.media.shared_icon")
  }

  static getString(): Resource {
    return $r("app.string.shared_library_context_name")
  }
}