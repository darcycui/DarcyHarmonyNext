// C-API 与 JS 桥接

export const add: (a: number, b: number) => number;

// C-API 创建UI
export const createNativeRoot: (content: Object) => void;

// C-API 销毁UI
export const destroyNativeRoot: () => void;