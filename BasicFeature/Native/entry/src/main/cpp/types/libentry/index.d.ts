import image from '@ohos.multimedia.image';

export const add: (a: number, b: number) => number;
export const nativeCallArkTS: (a: Function) => string;
export const nativeUvLoop: () => number;
export const packRawPixelMap: (path: string, mimeType: string, quality: number) => number;
export const packNapiPixelMap: (
  pixelMap: image.PixelMap,
  path: string,
  mimeType: string,
  quality: number
) => number;
