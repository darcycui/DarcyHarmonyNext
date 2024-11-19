import cameraNapi from 'liblibrary_camera.so';

export function nativeAdd(a: number, b: number): number {
  return cameraNapi.add(a, b)
}