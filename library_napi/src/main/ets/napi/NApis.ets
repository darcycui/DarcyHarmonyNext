import cameraNapi from 'liblibrary_napi.so';

export function nativeAdd(a: number, b: number): number {
  return cameraNapi.add(a, b)
}