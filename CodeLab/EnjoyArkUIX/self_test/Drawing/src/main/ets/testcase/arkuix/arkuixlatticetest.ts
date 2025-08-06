
import drawing from "@ohos.graphics.drawing";
import { TestBase } from '../../pages/testbase';
import { common2D } from "@kit.ArkGraphics2D";
import image from '@ohos.multimedia.image';
import globalThis from '../../utils/globalThis';

export class ArkuiXLatticeTest extends TestBase {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    {
      let pixelMap: image.PixelMap = globalThis.getInstance().getPixelMap("test_1.jpg");
      canvas.drawImage(pixelMap, 100, 50);
      let xDivs: Array<number> = [1, 2, 4];
      let yDivs: Array<number> = [1, 2, 4];
      let colorArray: Array<number> =
        [0xffffff, 0x444444, 0x999999, 0xffffff, 0x444444, 0x999999, 0xffffff, 0x444444, 0x999999, 0x444444, 0x999999,
          0xffffff, 0x444444, 0x999999, 0xffffff, 0x444444];
      let lattice = drawing.Lattice.createImageLattice(xDivs, yDivs, 3, 3, null, null, colorArray);
      let dst: common2D.Rect = {
        left: 100,
        top: 200,
        right: 250,
        bottom: 350
      };
      canvas.drawImageLattice(pixelMap, lattice, dst, drawing.FilterMode.FILTER_MODE_NEAREST);
    }

    {
      let pixelMap: image.PixelMap = globalThis.getInstance().getPixelMap("test_1.jpg");
      let xDivs: Array<number> = [1, 2, 4];
      let yDivs: Array<number> = [1, 2, 4];
      let color: common2D.Color = {
        alpha: 0xFF,
        red: 0x55,
        green: 0xFF,
        blue: 0x44
      };
      let colorArray2: Array<common2D.Color> =
        [color, color, color, color, color, color, color, color, color, color, color, color, color, color, color, color]
      let lattice2 = drawing.Lattice.createImageLattice(xDivs, yDivs, 3, 3, null, null, colorArray2);
      let dst2: common2D.Rect = {
        left: 100,
        top: 360,
        right: 250,
        bottom: 510
      };
      canvas.drawImageLattice(pixelMap, lattice2, dst2, drawing.FilterMode.FILTER_MODE_NEAREST);
    }
  }
}

export class ArkuiXRectTypeLatticeTest extends TestBase {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    {
      let pixelMap: image.PixelMap = globalThis.getInstance().getPixelMap("test_1.jpg");
      let xDivs: Array<number> = [1, 2, 4];
      let yDivs: Array<number> = [1, 2, 4];
      let colorArray: Array<number> =
        [0xffffff, 0x444444, 0x999999, 0xffffff, 0x444444, 0x999999, 0xffffff, 0x444444, 0x999999, 0x444444, 0x999999,
          0xffffff, 0x444444, 0x999999, 0xffffff, 0x444444];

      let fRectTypes: Array<drawing.RectType> =
        [drawing.RectType.FIXEDCOLOR, drawing.RectType.FIXEDCOLOR, drawing.RectType.FIXEDCOLOR,
          drawing.RectType.FIXEDCOLOR,
          drawing.RectType.FIXEDCOLOR, drawing.RectType.FIXEDCOLOR, drawing.RectType.FIXEDCOLOR,
          drawing.RectType.FIXEDCOLOR,
          drawing.RectType.FIXEDCOLOR, drawing.RectType.FIXEDCOLOR, drawing.RectType.FIXEDCOLOR,
          drawing.RectType.FIXEDCOLOR,
          drawing.RectType.FIXEDCOLOR, drawing.RectType.FIXEDCOLOR, drawing.RectType.FIXEDCOLOR,
          drawing.RectType.FIXEDCOLOR];
      let lattice = drawing.Lattice.createImageLattice(xDivs, yDivs, 3, 3, null, fRectTypes, colorArray);
      let dst: common2D.Rect = {
        left: 100,
        top: 50,
        right: 250,
        bottom: 200
      };
      canvas.drawImageLattice(pixelMap, lattice, dst, drawing.FilterMode.FILTER_MODE_NEAREST);
    }

    {
      let pixelMap: image.PixelMap = globalThis.getInstance().getPixelMap("test_1.jpg");
      let xDivs: Array<number> = [1, 2, 4];
      let yDivs: Array<number> = [1, 2, 4];
      let colorArray: Array<number> =
        [0xffffff, 0x444444, 0x999999, 0xffffff, 0x444444, 0x999999, 0xffffff, 0x444444, 0x999999, 0x444444, 0x999999,
          0xffffff, 0x444444, 0x999999, 0xffffff, 0x444444];
      let fRectTypes2: Array<drawing.RectType> =
        [drawing.RectType.DEFAULT, drawing.RectType.DEFAULT, drawing.RectType.DEFAULT, drawing.RectType.DEFAULT,
          drawing.RectType.DEFAULT, drawing.RectType.DEFAULT, drawing.RectType.DEFAULT, drawing.RectType.DEFAULT,
          drawing.RectType.DEFAULT, drawing.RectType.DEFAULT, drawing.RectType.DEFAULT, drawing.RectType.DEFAULT,
          drawing.RectType.DEFAULT, drawing.RectType.DEFAULT, drawing.RectType.DEFAULT, drawing.RectType.DEFAULT];
      let lattice2 = drawing.Lattice.createImageLattice(xDivs, yDivs, 3, 3, null, fRectTypes2, colorArray);
      let dst2: common2D.Rect = {
        left: 100,
        top: 300,
        right: 250,
        bottom: 450
      };
      canvas.drawImageLattice(pixelMap, lattice2, dst2, drawing.FilterMode.FILTER_MODE_NEAREST);
    }

    {
      let pixelMap: image.PixelMap = globalThis.getInstance().getPixelMap("test_1.jpg");
      let xDivs: Array<number> = [1, 2, 4];
      let yDivs: Array<number> = [1, 2, 4];
      let colorArray: Array<number> =
        [0xffffff, 0x444444, 0x999999, 0xffffff, 0x444444, 0x999999, 0xffffff, 0x444444, 0x999999, 0x444444, 0x999999,
          0xffffff, 0x444444, 0x999999, 0xffffff, 0x444444];
      let fRectTypes3: Array<drawing.RectType> =
        [drawing.RectType.TRANSPARENT, drawing.RectType.TRANSPARENT, drawing.RectType.TRANSPARENT,
          drawing.RectType.TRANSPARENT,
          drawing.RectType.TRANSPARENT, drawing.RectType.TRANSPARENT, drawing.RectType.TRANSPARENT,
          drawing.RectType.TRANSPARENT,
          drawing.RectType.TRANSPARENT, drawing.RectType.TRANSPARENT, drawing.RectType.TRANSPARENT,
          drawing.RectType.TRANSPARENT,
          drawing.RectType.TRANSPARENT, drawing.RectType.TRANSPARENT, drawing.RectType.TRANSPARENT,
          drawing.RectType.TRANSPARENT];
      let lattice3 = drawing.Lattice.createImageLattice(xDivs, yDivs, 3, 3, null, fRectTypes3, colorArray);
      let dst3: common2D.Rect = {
        left: 300,
        top: 500,
        right: 450,
        bottom: 650
      };
      canvas.drawImageLattice(pixelMap, lattice3, dst3, drawing.FilterMode.FILTER_MODE_NEAREST);
    }
  }
}