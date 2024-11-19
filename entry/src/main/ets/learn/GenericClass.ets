/**
 * 泛型类
 * TODO 泛型默认值为number类型
 */
import { HashMap } from '@kit.ArkTS';

export class GenericClass<T = number> {
  t: T

  constructor(t: T) {
    this.t = t
  }

  putValue(t: T) {
    this.t = t;
  }

  getValue(): T {
    return this.t
  }
}

interface Hashable {
  hash(): number
}

/**
 * 泛型K限制为Hashable及其子类 TODO: 使用extends
 */
class MyHashMap<K extends Hashable, V> {
  key?: K
  value?: V

  put(key: K, value: V) {
    this.key = key
    this.value = value
  }

  get(key: K): V | undefined {
    return this.value
  }
}
