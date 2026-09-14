export class ObjectUtil {
  static getObjectText(obj: Object): string {
    if (typeof obj === 'string') {
      return obj
    } else {
      return JSON.stringify(obj);
    }
  }
}