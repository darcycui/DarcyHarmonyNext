/**
 * 获取资源字符串
 * @param component
 * @param id 资源id
 * @returns string
 */
export function getResourceString(component: object, id: Resource): string {
  return getContext(component).resourceManager.getStringSync(id)
}