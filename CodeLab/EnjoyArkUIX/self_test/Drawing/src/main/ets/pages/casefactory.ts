/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {TestBase, StyleType} from './testbase';
import {
  CanvasDrawRectTest, CanvasDrawRectParamTest, CanvasDrawRoundRectTest,
  CanvasDrawRoundNestedRectTest, CanvasDrawBackgroundTest, CanvasDrawShadowTest,
  CanvasDrawShadowParamTest, CanvasDrawCircleTest, CanvasDrawImageTest,
  CanvasDrawImageLatticeTest, CanvasDrawImageNineTest, CanvasDrawImageRectTest,
  CanvasDrawImageRectWithSrcTest, CanvasDrawColorTest, CanvasDrawOvalTest,
  CanvasDrawArcTest, CanvasDrawArcWithCenterTest, CanvasDrawPointTest,
  CanvasDrawPointsTest, CanvasDrawPathTest, CanvasDrawLineTest,
  CanvasDrawSingleCharacterTest, CanvasDrawTextBlobTest, CanvasDrawPixelMapMeshTest,
  CanvasDrawRegionTest, CanvasSaveAndRestoreTest, CanvasSaveLayerTest,
  CanvasClearTest, CanvasRestoreAndSaveCountTest, CanvasGetWidthAndHeightTest,
  CanvasGetLocalClipBoundsTest, CanvasGetTotalMatrixTest, CanvasScaleTest,
  CanvasSkewTest, CanvasRotateTest, CanvasTranslateTest,
  CanvasClipPathTest, CanvasClipRectTest, CanvasConcatMatrixTest,
  CanvasClipRegionTest, CanvasClipRoundRectTest, CanvasIsClipEmptyTest,
  CanvasSetMatrixTest, CanvasResetMatrixTest, CanvasQuickRejectPathTest,
  CanvasQuickRejectRectTest}
  from '../testcase/arkuix/arkuixcanvastest';
import {
  MatrixSetRotationTest, MatrixSetScaleTest, MatrixSetTranslationTest,
  MatrixSetMatrixTest, MatrixPreConcatTest, MatrixIsEqualTest,
  MatrixInvertTest, MatrixIsIdentityTest, MatrixGetValueTest,
  MatrixPostRotateTest, MatrixPostScaleTest, MatrixPostTranslateTest,
  MatrixPreRotateTest, MatrixPreScaleTest, MatrixPreTranslateTest,
  MatrixResetTest, MatrixMapPointsTest, MatrixGetAllTest,
  MatrixMapRectTest, MatrixSetRectToRectTest, MatrixSetPolyToPolyTest,
  MatrixConstructorTest, MatrixIsAffineTest, MatrixRectStaysRectTest,
  MatrixSetSkewTest, MatrixSetSinCosTest, MatrixSetMatrixWithMatrixTest,
  MatrixSetConcatTest, MatrixPostConcatTest, MatrixPreSkewTest,
  MatrixPostSkewTest, MatrixMapRadiusTest}
  from '../testcase/arkuix/arkuixmatrixtest';

import {
  RegionIsPointContainedTest, RegionIsRegionContainedTest, RegionOpTest,
  RegionQuickRejectTest, RegionSetPathTest, RegionSetRectTest, RegionConstructorTest,
  RegionIsEqualTest, RegionIsComplexTest, RegionIsEmptyTest, RegionGetBoundsTest,
  RegionGetBoundaryPathTest, RegionOffsetTest, RegionQuickRejectRegionTest, RegionSetRegionTest,
  RegionSetEmptyTest}
  from '../testcase/arkuix/arkuixregiontest';

import {
  ArkuiXPenMiterLimitTest,
  ArkuiXPenSetShaderEffectTest,
  ArkuiXPenSetColorTest,
  ArkuiXPenGetColorTest,
  ArkuiXPenSetColor4fTest1,
  ArkuiXPenSetColor4fTest2,
  ArkuiXPenSetColor4fTest3,
  ArkuiXPenGetColor4fTest,
  ArkuiXPenGetHexColorTest,
  ArkuiXPenWidthTest,
  ArkuiXPenAntiAliasTest,
  ArkuiXPenAlphaTest,
  ArkuiXPenColorFilterTest,
  ArkuiXPenSetImageFilterTest,
  ArkuiXPenSetMaskFilterTest,
  ArkuiXPenSetPathEffectTest,
  ArkuiXPenSetShadowLayerTest,
  ArkuiXPenSetBlendMode1Test,
  ArkuiXPenSetBlendMode2Test,
  ArkuiXPenSetBlendMode3Test,
  ArkuiXPenSetDitherTest,
  ArkuiXPenJoinStyleTest,
  ArkuiXPenCapStyleTest,
  ArkuiXPenResetTest,
  ArkuiXPenGetFillPathTest
} from '../testcase/arkuix/arkuixpentest';
import {
  ArkuiXBrushSetShaderEffectTest,
  ArkuiXBrushSetColorTest,
  ArkuiXBrushGetColorTest,
  ArkuiXBrushSetColor4fTest1,
  ArkuiXBrushSetColor4fTest2,
  ArkuiXBrushSetColor4fTest3,
  ArkuiXBrushGetColor4fTest,
  ArkuiXBrushGetHexColorTest,
  ArkuiXBrushSetAntiAliasTest,
  ArkuiXBrushIsAntiAliasTest,
  ArkuiXBrushGetAlphaTest,
  ArkuiXBrushSetAlphaTest,
  ArkuiXBrushSetColorFilterTest,
  ArkuiXBrushGetColorFilterTest,
  ArkuiXBrushSetImageFilterTest,
  ArkuiXBrushSetMaskFilterTest,
  ArkuiXBrushSetShadowLayerTest,
  ArkuiXBrushSetBlendModeTest,
  ArkuiXBrushResetTest
} from '../testcase/arkuix/arkuixbrushtest';
import {
  ArkuiXRoundRectConstructTest,
  ArkuiXRoundRectSetCornerTest,
  ArkuiXRoundRectGetCornerTest,
  ArkuiXRoundRectOffsetTest
} from '../testcase/arkuix/arkuixroundrecttest';
import { ArkuiXMaskFilterTest } from '../testcase/arkuix/arkuixmaskfiltertest';
import {
  ArkuiXDashStyleRotateTest,
  ArkuiXDashStyleMorphTest,
  ArkuiXDashStyleTranslateTest
} from '../testcase/arkuix/arkuixpathdashstyletest';
import {
  ArkuiXFontMetricsFlagsTest
} from '../testcase/arkuix/arkuixfontmetricsflagstest'

import {
  ArkuiXDashPathEffectTest,
  ArkuiXPathDashEffectTest,
  ArkuiXCornerPathEffectTest,
  ArkuiXDiscretePathEffectTest,
  ArkuiXComposePathEffectTest,
  ArkuiXSumPathEffectTest
} from '../testcase/arkuix/arkuixpatheffecttest'
import { ArkuiXShadowLayerTest } from '../testcase/arkuix/arkuixshadowlayertest'
import {
  ArkuiXColorShaderTest,
  ArkuiXLinearGradientTest,
  ArkuiXRadialGradientTest,
  ArkuiXSweepGradientTest,
  ArkuiXConicalGradientTest,
  ArkuiXCreateImageShaderTest,
  ArkuiXCreateComposeShaderTest
} from '../testcase/arkuix/arkuixshadereffecttest'
import {
  ArkuiXBlendModeColorFilterTest,
  ArkuiXComposeColorFilterTest,
  ArkuiXLinearToSRGBGammaTest,
  ArkuiXSRGBGammaToLinearTest,
  ArkuiXLumaColorFilterTest,
  ArkuiXMatrixColorFilterTest,
  ArkuiXCreateLightingColorFilterTest
} from '../testcase/arkuix/arkuixcolorfiltertest'
import {
  ArkuiXBlurImageFilterTest,
  ArkuiXFromColorFilterTest,
  ArkuiXCreateOffsetImageFilterTest,
  ArkuiXCreateFromImageTest,
  ArkuiXCreateBlendImageFilterTest,
  ArkuiXCreateComposeImageFilterTest,
  ArkuiXCreateFromShaderEffectTest
} from '../testcase/arkuix/arkuiximagefiltertest'
import { ArkuiXTileModeTest } from '../testcase/arkuix/arkuixtilemodetest'
import {
  ToolMakeColorFromResourceColorTest1,
  ToolMakeColorFromResourceColorTest2,
  ToolMakeColorFromResourceColorTest3,
  ToolMakeColorFromResourceColorTest4,
} from '../testcase/arkuix/arkuixtooltest'
import { ArkuiXLatticeTest, ArkuiXRectTypeLatticeTest } from '../testcase/arkuix/arkuixlatticetest'
import { ArkuiXFontSubpixelTest,
  ArkuiXFontEmboldenTest,
  ArkuiXFontLinearMetricsTest,
  ArkuiXFontSizeTest,
  ArkuiXFontTypefaceTest,
  ArkuiXFontMetricsTest,
  ArkuiXMeasureSingleCharacterTest,
  ArkuiXMeasureTextTest,
  ArkuiXFontScaleXTest,
  ArkuiXFontSkewXTest,
  ArkuiXFontEdgingTest,
  ArkuiXFontHintingTest,
  ArkuiXCountTextTest,
  ArkuiXBaselineSnapTest,
  ArkuiXEmbeddedBitmapsTest,
  ArkuiXForceAutoHintingTest,
  ArkuiXThemeFontFollowedTest,
  ArkuiXGetWidthsTest,
  ArkuiXTextToGlyphsTest,
  ArkuiXPathForGlyphTest,
  ArkuiXGetBoundsTest,
  ArkuiXGetTextPathTest
} from '../testcase/arkuix/arkuixfonttest'
import {
  ArkuiXMakeFromStringTest,
  ArkuiXMakeFromPosTextTest,
  ArkuiXMakeFromRunBufferTest,
  ArkuiXBoundsTest,
  ArkuiXUniqueIDTest
} from '../testcase/arkuix/arkuixtextblobtest'
import { ArkuiXClipOpDifferenceTest, ArkuiXClipOpIntersectTest } from '../testcase/arkuix/arkuixclipoptest'
import {
  ArkuiXGetFamilyNameTest,
  ArkuiXMakeFromFileTest,
  ArkuiXMakeFromRawFileTest
} from '../testcase/arkuix/arkuixtypefacetest'
import {ArkuiXPathMoveTo, ArkuiXPathLineTo, ArkuiXPathArcTo, ArkuiXPathQuadTo, ArkuiXPathConicTo, ArkuiXPathCubicTo,
  ArkuiXPathRMoveTo, ArkuiXPathRLineTo, ArkuiXPathRQuadTo, ArkuiXPathRConicTo, ArkuiXPathRCubicTo, ArkuiXPathAddPolygon,
  ArkuiXPathOp, ArkuiXPathAddArc, ArkuiXPathAddCircle,ArkuiXPathAddOval, ArkuiXPathAddRect, ArkuiXPathAddRoundRect,
  ArkuiXPathAddPath, ArkuiXPathContains, ArkuiXPathSetFillType, ArkuiXPathClose, ArkuiXPathOffset, ArkuiXPathReset,
  ArkuiXPathIsClosed, ArkuiXPathGetPositionAndTangent, ArkuiXPathGetSegment, ArkuiXPathGetMatrix, ArkuiXPathGetLength,
  ArkuiXPathBuildFromSvgString, ArkuiXPathConstructor, ArkuiXPathGetPathIterator, ArkuiXPathTransform, ArkuiXPathGetBounds,
  ArkuiXPathDirection, ArkuiXPathMeasureMatrixFlags, ArkuiXPathSet, ArkuiXPathSetLastPoint, ArkuiXPathGetFillType,
  ArkuiXPathReWindAndIsEmpty, ArkuiXPathIsRect, ArkuiXPathApproximate, ArkuiXPathInterpolate, ArkuiXPathIsInterpolate
} from '../testcase/arkuix/arkuixpathtest'
import { ArkuiXPathIteratorConstructor, ArkuiXPathIteratorNext, ArkuiXPathIteratorHasNext, ArkuiXPathIteratorPeek,
  ArkuiXPathIteratorVerb} from '../testcase/arkuix/arkuixpathiteratortest';
import { ArkuiXSamplingOptionsTest } from '../testcase/arkuix/arkuixsamplingoptionstest'
import { ArkuiXShadowFlagTest } from '../testcase/arkuix/arkuixshadowflagtest'
import { ArkuiXPointModeTest } from '../testcase/arkuix/arkuixpointmodetest'
import {
  ArkuiXMakeFromCurrentTest,
  ArkuiXMakeFromFileWithArgumentsTest,
  ArkuiXMakeFromRawFileWithArgumentsTest
} from '../testcase/arkuix/arkuixtypefaceargumentstest'
const TAG = '[DrawingTest]';

export class CaseFactory {
  static ArkuixMap: Map<string, Function> = new Map(
    [
      //canvas
      ['ArkuiXCanvasDrawRectTest', () => { return new CanvasDrawRectTest(); }],
      ['ArkuiXCanvasDrawRectParamTest', () => { return new CanvasDrawRectParamTest(); }],
      ['ArkuiXCanvasDrawRoundRectTest', () => { return new CanvasDrawRoundRectTest(); }],
      ['ArkuiXCanvasDrawRoundNestedRectTest', () => { return new CanvasDrawRoundNestedRectTest(); }],
      ['ArkuiXCanvasDrawBackgroundTest', () => { return new CanvasDrawBackgroundTest(); }],
      ['ArkuiXCanvasDrawShadowTest', () => { return new CanvasDrawShadowTest(); }],
      ['ArkuiXCanvasDrawShadowParamTest', () => { return new CanvasDrawShadowParamTest(); }],
      ['ArkuiXCanvasDrawCircleTest', () => { return new CanvasDrawCircleTest(); }],
      ['ArkuiXCanvasDrawImageTest', () => { return new CanvasDrawImageTest(); }],
      ['ArkuiXCanvasDrawImageLatticeTest', () => { return new CanvasDrawImageLatticeTest(); }],
      ['ArkuiXCanvasDrawImageNineTest', () => { return new CanvasDrawImageNineTest(); }],
      ['ArkuiXCanvasDrawImageRectTest', () => { return new CanvasDrawImageRectTest(); }],
      ['ArkuiXCanvasDrawImageRectWithSrcTest', () => { return new CanvasDrawImageRectWithSrcTest(); }],
      ['ArkuiXCanvasDrawColorTest', () => { return new CanvasDrawColorTest(); }],
      ['ArkuiXCanvasDrawOvalTest', () => { return new CanvasDrawOvalTest(); }],
      ['ArkuiXCanvasDrawArcTest', () => { return new CanvasDrawArcTest(); }],
      ['ArkuiXCanvasDrawArcWithCenterTest', () => { return new CanvasDrawArcWithCenterTest(); }],
      ['ArkuiXCanvasDrawPointTest', () => { return new CanvasDrawPointTest(); }],
      ['ArkuiXCanvasDrawPointsTest', () => { return new CanvasDrawPointsTest(); }],
      ['ArkuiXCanvasDrawPathTest', () => { return new CanvasDrawPathTest(); }],
      ['ArkuiXCanvasDrawLineTest', () => { return new CanvasDrawLineTest(); }],
      ['ArkuiXCanvasDrawSingleCharacterTest', () => { return new CanvasDrawSingleCharacterTest(); }],
      ['ArkuiXCanvasDrawTextBlobTest', () => { return new CanvasDrawTextBlobTest(); }],
      ['ArkuiXCanvasDrawPixelMapMeshTest', () => { return new CanvasDrawPixelMapMeshTest(); }],
      ['ArkuiXCanvasDrawRegionTest', () => { return new CanvasDrawRegionTest(); }],
      ['ArkuiXCanvasSaveAndRestoreTest', () => { return new CanvasSaveAndRestoreTest(); }],
      ['ArkuiXCanvasSaveLayerTest', () => { return new CanvasSaveLayerTest(); }],
      ['ArkuiXCanvasClearTest', () => { return new CanvasClearTest(); }],
      ['ArkuiXCanvasRestoreAndSaveCountTest', () => { return new CanvasRestoreAndSaveCountTest(); }],
      ['ArkuiXCanvasGetWidthAndHeightTest', () => { return new CanvasGetWidthAndHeightTest(); }],
      ['ArkuiXCanvasGetLocalClipBoundsTest', () => { return new CanvasGetLocalClipBoundsTest(); }],
      ['ArkuiXCanvasGetTotalMatrixTest', () => { return new CanvasGetTotalMatrixTest(); }],
      ['ArkuiXCanvasScaleTest', () => { return new CanvasScaleTest(); }],
      ['ArkuiXCanvasSkewTest', () => { return new CanvasSkewTest(); }],
      ['ArkuiXCanvasRotateTest', () => { return new CanvasRotateTest(); }],
      ['ArkuiXCanvasTranslateTest', () => { return new CanvasTranslateTest(); }],
      ['ArkuiXCanvasClipPathTest', () => { return new CanvasClipPathTest(); }],
      ['ArkuiXCanvasClipRectTest', () => { return new CanvasClipRectTest(); }],
      ['ArkuiXCanvasConcatMatrixTest', () => { return new CanvasConcatMatrixTest(); }],
      ['ArkuiXCanvasClipRegionTest', () => { return new CanvasClipRegionTest(); }],
      ['ArkuiXCanvasClipRoundRectTest', () => { return new CanvasClipRoundRectTest(); }],
      ['ArkuiXCanvasIsClipEmptyTest', () => { return new CanvasIsClipEmptyTest(); }],
      ['ArkuiXCanvasSetMatrixTest', () => { return new CanvasSetMatrixTest(); }],
      ['ArkuiXCanvasResetMatrixTest', () => { return new CanvasResetMatrixTest(); }],
      ['ArkuiXCanvasQuickRejectPathTest', () => { return new CanvasQuickRejectPathTest(); }],
      ['ArkuiXCanvasQuickRejectRectTest', () => { return new CanvasQuickRejectRectTest(); }],

      //matrix
      ['ArkuiXMatrixSetRotationTest', () => { return new MatrixSetRotationTest(); }],
      ['ArkuiXMatrixSetScaleTest', () => { return new MatrixSetScaleTest(); }],
      ['ArkuiXMatrixSetTranslationTest', () => { return new MatrixSetTranslationTest(); }],
      ['ArkuiXMatrixSetMatrixTest', () => { return new MatrixSetMatrixTest(); }],
      ['ArkuiXMatrixPreConcatTest', () => { return new MatrixPreConcatTest(); }],
      ['ArkuiXMatrixIsEqualTest', () => { return new MatrixIsEqualTest(); }],
      ['ArkuiXMatrixInvertTest', () => { return new MatrixInvertTest(); }],
      ['ArkuiXMatrixIsIdentityTest', () => { return new MatrixIsIdentityTest(); }],
      ['ArkuiXMatrixGetValueTest', () => { return new MatrixGetValueTest(); }],
      ['ArkuiXMatrixPostRotateTest', () => { return new MatrixPostRotateTest(); }],
      ['ArkuiXMatrixPostScaleTest', () => { return new MatrixPostScaleTest(); }],
      ['ArkuiXMatrixPostTranslateTest', () => { return new MatrixPostTranslateTest(); }],
      ['ArkuiXMatrixPreRotateTest', () => { return new MatrixPreRotateTest(); }],
      ['ArkuiXMatrixPreScaleTest', () => { return new MatrixPreScaleTest(); }],
      ['ArkuiXMatrixPreTranslateTest', () => { return new MatrixPreTranslateTest(); }],
      ['ArkuiXMatrixResetTest', () => { return new MatrixResetTest(); }],
      ['ArkuiXMatrixMapPointsTest', () => { return new MatrixMapPointsTest(); }],
      ['ArkuiXMatrixGetAllTest', () => { return new MatrixGetAllTest(); }],
      ['ArkuiXMatrixMapRectTest', () => { return new MatrixMapRectTest(); }],
      ['ArkuiXMatrixSetRectToRectTest', () => { return new MatrixSetRectToRectTest(); }],
      ['ArkuiXMatrixSetPolyToPolyTest', () => { return new MatrixSetPolyToPolyTest(); }],
      ['ArkuiXMatrixConstructorTest', () => {return new MatrixConstructorTest();}],
      ['ArkuiXMatrixIsAffineTest', () => {return new MatrixIsAffineTest();}],
      ['ArkuiXMatrixRectStaysRectTest', () => {return new MatrixRectStaysRectTest();}],
      ['ArkuiXMatrixSetSkewTest', () => {return new MatrixSetSkewTest();}],
      ['ArkuiXMatrixSetSinCosTest', () => {return new MatrixSetSinCosTest();}],
      ['ArkuiXMatrixSetMatrixWithMatrixTest', () => {return new MatrixSetMatrixWithMatrixTest();}],
      ['ArkuiXMatrixSetConcatTest', () => {return new MatrixSetConcatTest();}],
      ['ArkuiXMatrixPostConcatTest', () => {return new MatrixPostConcatTest();}],
      ['ArkuiXMatrixPreSkewTest', () => {return new MatrixPreSkewTest();}],
      ['ArkuiXMatrixPostSkewTest', () => {return new MatrixPostSkewTest();}],
      ['ArkuiXMatrixMapRadiusTest', () => {return new MatrixMapRadiusTest();}],

      //region
      ['ArkuiXRegionIsPointContainedTest', () => { return new RegionIsPointContainedTest(); }],
      ['ArkuiXRegionIsRegionContainedTest', () => { return new RegionIsRegionContainedTest(); }],
      ['ArkuiXRegionOpTest', () => { return new RegionOpTest(); }],
      ['ArkuiXRegionQuickRejectTest', () => { return new RegionQuickRejectTest(); }],
      ['ArkuiXRegionSetPathTest', () => { return new RegionSetPathTest(); }],
      ['ArkuiXRegionSetRectTest', () => { return new RegionSetRectTest(); }],
      ['ArkuiXRegionConstructorTest', () => { return new RegionConstructorTest(); }],
      ['ArkuiXRegionIsEqualTest', () => { return new RegionIsEqualTest(); }],
      ['ArkuiXRegionIsComplexTest', () => { return new RegionIsComplexTest(); }],
      ['ArkuiXRegionIsEmptyTest', () => { return new RegionIsEmptyTest(); }],
      ['ArkuiXRegionGetBoundsTest', () => { return new RegionGetBoundsTest(); }],
      ['ArkuiXRegionGetBoundaryPathTest', () => { return new RegionGetBoundaryPathTest(); }],
      ['ArkuiXRegionOffsetTest', () => { return new RegionOffsetTest(); }],
      ['ArkuiXRegionQuickRejectRegionTest', () => { return new RegionQuickRejectRegionTest(); }],
      ['ArkuiXRegionSetRegionTest', () => { return new RegionSetRegionTest(); }],
      ['ArkuiXRegionSetEmptyTest', () => { return new RegionSetEmptyTest(); }],

      //pen
      ['ArkuiXPenMiterlimitTest', () => {return new ArkuiXPenMiterLimitTest();}],
      ['ArkuiXPenSetshadereffectTest', () => {return new ArkuiXPenSetShaderEffectTest();}],
      ['ArkuiXPenSetcolorTest', () => {return new ArkuiXPenSetColorTest();}],
      ['ArkuiXPenGetcolorTest', () => {return new ArkuiXPenGetColorTest();}],
      ['ArkuiXPenSetColor4fTest1', () => {return new ArkuiXPenSetColor4fTest1();}],
      ['ArkuiXPenSetColor4fTest2', () => {return new ArkuiXPenSetColor4fTest2();}],
      ['ArkuiXPenSetColor4fTest3', () => {return new ArkuiXPenSetColor4fTest3();}],
      ['ArkuiXPenGetcolor4fTest', () => {return new ArkuiXPenGetColor4fTest();}],
      ['ArkuiXPenGethexcolorTest', () => {return new ArkuiXPenGetHexColorTest();}],
      ['ArkuiXPenWidthTest', () => {return new ArkuiXPenWidthTest();}],
      ['ArkuiXPenAntialiasTest', () => {return new ArkuiXPenAntiAliasTest();}],
      ['ArkuiXPenAlphaTest', () => {return new ArkuiXPenAlphaTest();}],
      ['ArkuiXPenColorfilterTest', () => {return new ArkuiXPenColorFilterTest();}],
      ['ArkuiXPenSetimagefilterTest', () => {return new ArkuiXPenSetImageFilterTest();}],
      ['ArkuiXPenSetmaskfilterTest', () => {return new ArkuiXPenSetMaskFilterTest();}],
      ['ArkuiXPenSetpatheffectTest', () => {return new ArkuiXPenSetPathEffectTest();}],
      ['ArkuiXPenSetshadowlayerTest', () => {return new ArkuiXPenSetShadowLayerTest();}],
      ['ArkuiXPenSetblendmode1Test', () => {return new ArkuiXPenSetBlendMode1Test();}],
      ['ArkuiXPenSetblendmode2Test', () => {return new ArkuiXPenSetBlendMode2Test();}],
      ['ArkuiXPenSetblendmode3Test', () => {return new ArkuiXPenSetBlendMode3Test();}],
      ['ArkuiXPenSetditherTest', () => {return new ArkuiXPenSetDitherTest();}],
      ['ArkuiXPenJoinstyleTest', () => {return new ArkuiXPenJoinStyleTest();}],
      ['ArkuiXPenCapstyleTest', () => {return new ArkuiXPenCapStyleTest();}],
      ['ArkuiXPenResetTest', () => {return new ArkuiXPenResetTest();}],
      ['ArkuiXPenGetfillpathTest', () => {return new ArkuiXPenGetFillPathTest();}],

      //brush
      ['ArkuiXBrushSetcolorTest', () => {return new ArkuiXBrushSetColorTest();}],
      ['ArkuiXBrushGetcolorTest', () => {return new ArkuiXBrushGetColorTest();}],
      ['ArkuiXBrushSetColor4fTest1', () => {return new ArkuiXBrushSetColor4fTest1();}],
      ['ArkuiXBrushSetColor4fTest2', () => {return new ArkuiXBrushSetColor4fTest2();}],
      ['ArkuiXBrushSetColor4fTest3', () => {return new ArkuiXBrushSetColor4fTest3();}],
      ['ArkuiXBrushGetcolor4fTest', () => {return new ArkuiXBrushGetColor4fTest();}],
      ['ArkuiXBrushGethexcolorTest', () => {return new ArkuiXBrushGetHexColorTest();}],
      ['ArkuiXBrushSetantialiasTest', () => {return new ArkuiXBrushSetAntiAliasTest();}],
      ['ArkuiXBrushIsantialiasTest', () => {return new ArkuiXBrushIsAntiAliasTest();}],
      ['ArkuiXBrushGetalphaTest', () => {return new ArkuiXBrushGetAlphaTest();}],
      ['ArkuiXBrushSetalphaTest', () => {return new ArkuiXBrushSetAlphaTest();}],
      ['ArkuiXBrushSetcolorfilterTest', () => {return new ArkuiXBrushSetColorFilterTest();}],
      ['ArkuiXBrushGetcolorfilterTest', () => {return new ArkuiXBrushGetColorFilterTest();}],
      ['ArkuiXBrushSetimagefilterTest', () => {return new ArkuiXBrushSetImageFilterTest();}],
      ['ArkuiXBrushSetmaskfilterTest', () => {return new ArkuiXBrushSetMaskFilterTest();}],
      ['ArkuiXBrushSetshadowlayerTest', () => {return new ArkuiXBrushSetShadowLayerTest();}],
      ['ArkuiXBrushSetshadereffectTest', () => {return new ArkuiXBrushSetShaderEffectTest();}],
      ['ArkuiXBrushSetblendmodeTest', () => {return new ArkuiXBrushSetBlendModeTest();}],
      ['ArkuiXBrushResetTest', () => {return new ArkuiXBrushResetTest();}],

      //akruixroundrect
      ['ArkuiXRoundRectConstructTest', () => {return new ArkuiXRoundRectConstructTest();}],
      ['ArkuiXRoundRectSetcornerTest', () => {return new ArkuiXRoundRectSetCornerTest();}],
      ['ArkuiXRoundRectGetcornerTest', () => {return new ArkuiXRoundRectGetCornerTest();}],
      ['ArkuiXRoundRectOffsetTest', () => {return new ArkuiXRoundRectOffsetTest();}],

      //maskfilter
      ['ArkuiXMaskfilterTest', () => {return new ArkuiXMaskFilterTest();}],

      //PathDashStyle
      ['ArkuiXDashstyletranslateTest', () => {return new ArkuiXDashStyleTranslateTest();}],
      ['ArkuiXDashstylerotateTest', () => {return new ArkuiXDashStyleRotateTest();}],
      ['ArkuiXDashstylemorphTest', () => {return new ArkuiXDashStyleMorphTest();}],

      //MetricsFlags
      ['ArkuiXFontmetricsflagsTest', () => {return new ArkuiXFontMetricsFlagsTest();}],

      //patheffect
      ['ArkuiXDashpatheffectTest', () => {return new ArkuiXDashPathEffectTest();}],
      ['ArkuiXPathdasheffectTest', () => {return new ArkuiXPathDashEffectTest();}],
      ['ArkuiXCornerpatheffectTest', () => {return new ArkuiXCornerPathEffectTest();}],
      ['ArkuiXDiscretepatheffectTest', () => {return new ArkuiXDiscretePathEffectTest();}],
      ['ArkuiXComposepatheffectTest', () => {return new ArkuiXComposePathEffectTest();}],
      ['ArkuiXSumpatheffectTest', () => {return new ArkuiXSumPathEffectTest();}],

      //shadowlayer
      ['ArkuiXShadowlayerTest', () => {return new ArkuiXShadowLayerTest();}],

      //shadereffect
      ['ArkuiXColorshaderTest', () => {return new ArkuiXColorShaderTest();}],
      ['ArkuiXLineargradientTest', () => {return new ArkuiXLinearGradientTest();}],
      ['ArkuiXRadialgradientTest', () => {return new ArkuiXRadialGradientTest();}],
      ['ArkuiXSweepgradientTest', () => {return new ArkuiXSweepGradientTest();}],
      ['ArkuiXConicalgradientTest', () => {return new ArkuiXConicalGradientTest();}],
      ['ArkuiXCreateImageShaderTest', () => { return new ArkuiXCreateImageShaderTest(); }],
      ['ArkuiXCreateComposeShaderTest', () => { return new ArkuiXCreateComposeShaderTest(); }],

      //colorfilter
      ['ArkuiXBlendmodecolorfilterTest', () => {return new ArkuiXBlendModeColorFilterTest();}],
      ['ArkuiXComposecolorfilterTest', () => {return new ArkuiXComposeColorFilterTest();}],
      ['ArkuiXLineartosrgbgammaTest', () => {return new ArkuiXLinearToSRGBGammaTest();}],
      ['ArkuiXSrgbammatolinearTest', () => {return new ArkuiXSRGBGammaToLinearTest();}],
      ['ArkuiXLumacolorfilterTest', () => {return new ArkuiXLumaColorFilterTest();}],
      ['ArkuiXMatrixcolorfilterTest', () => {return new ArkuiXMatrixColorFilterTest();}],
      ['ArkuiXCreateLightingColorFilterTest', () => { return new ArkuiXCreateLightingColorFilterTest(); }],

      //imagefilter
      ['ArkuiXFromcolorfilterTest', () => {return new ArkuiXFromColorFilterTest();}],
      ['ArkuiXBlurimagefilterTest', () => {return new ArkuiXBlurImageFilterTest();}],
      ['ArkuiXCreateOffsetImageFilterTest', () => { return new ArkuiXCreateOffsetImageFilterTest(); }],
      ['ArkuiXCreateFromImageTest', () => { return new ArkuiXCreateFromImageTest(); }],
      ['ArkuiXCreateBlendImageFilterTest', () => { return new ArkuiXCreateBlendImageFilterTest(); }],
      ['ArkuiXCreateComposeImageFilterTest', () => { return new ArkuiXCreateComposeImageFilterTest(); }],
      ['ArkuiXCreateFromShaderEffectTest', () => { return new ArkuiXCreateFromShaderEffectTest(); }],

      //tilemode
      ['ArkuiXTilemodeTest', () => {return new ArkuiXTileModeTest();}],

      //lattice
      ['ArkuiXLatticeTest', () => {return new ArkuiXLatticeTest();}],
      ['ArkuiXRecttypelatticeTest', () => {return new ArkuiXRectTypeLatticeTest();}],

      //font
      ['ArkuiXFontsubpixelTest', () => {return new ArkuiXFontSubpixelTest();}],
      ['ArkuiXFontemboldenTest', () => {return new ArkuiXFontEmboldenTest();}],
      ['ArkuiXFontlinearmetricsTest', () => {return new ArkuiXFontLinearMetricsTest();}],
      ['ArkuiXFontsizeTest', () => {return new ArkuiXFontSizeTest();}],
      ['ArkuiXFonttypefaceTest', () => {return new ArkuiXFontTypefaceTest();}],
      ['ArkuiXFontmetricsTest', () => {return new ArkuiXFontMetricsTest();}],
      ['ArkuiXMeasuresinglecharacterTest', () => {return new ArkuiXMeasureSingleCharacterTest();}],
      ['ArkuiXMeasuretextTest', () => {return new ArkuiXMeasureTextTest();}],
      ['ArkuiXFontscalexTest', () => {return new ArkuiXFontScaleXTest();}],
      ['ArkuiXFontskewxTest', () => {return new ArkuiXFontSkewXTest();}],
      ['ArkuiXFontedgingTest', () => {return new ArkuiXFontEdgingTest();}],
      ['ArkuiXFonthintingTest', () => {return new ArkuiXFontHintingTest();}],
      ['ArkuiXCounttextTest', () => {return new ArkuiXCountTextTest();}],
      ['ArkuiXBaselinesnapTest', () => {return new ArkuiXBaselineSnapTest();}],
      ['ArkuiXEmbeddedbitmapsTest', () => {return new ArkuiXEmbeddedBitmapsTest();}],
      ['ArkuiXForceautohintingTest', () => {return new ArkuiXForceAutoHintingTest();}],
      ['ArkuiXThemefontfollowedTest', () => {return new ArkuiXThemeFontFollowedTest();}],
      ['ArkuiXGetwidthsTest', () => {return new ArkuiXGetWidthsTest();}],
      ['ArkuiXTexttoglyphsTest', () => {return new ArkuiXTextToGlyphsTest();}],
      ['ArkuiXPathforglyphTest', () => {return new ArkuiXPathForGlyphTest();}],
      ['ArkuiXGetboundsTest', () => {return new ArkuiXGetBoundsTest();}],
      ['ArkuiXGettextpathTest', () => {return new ArkuiXGetTextPathTest();}],

      //textblob
      ['ArkuiXMakefromstringTest', () => {return new ArkuiXMakeFromStringTest();}],
      ['ArkuiXMakefrompostextTest', () => {return new ArkuiXMakeFromPosTextTest();}],
      ['ArkuiXMakefromrunbufferTest', () => {return new ArkuiXMakeFromRunBufferTest();}],
      ['ArkuiXBoundsTest', () => {return new ArkuiXBoundsTest();}],
      ['ArkuiXUniqueidTest', () => {return new ArkuiXUniqueIDTest();}],

      //clipOp
      ['ArkuiXClipopdifferenceTest', () => {return new ArkuiXClipOpDifferenceTest();}],
      ['ArkuiXClipopintersectTest', () => {return new ArkuiXClipOpIntersectTest();}],

      //typeface
      ['ArkuiXGetFamilyNameTest', () => {return new ArkuiXGetFamilyNameTest();}],
      ['ArkuiXMakefromfileTest', () => {return new ArkuiXMakeFromFileTest();}],
      ['ArkuiXMakeFromRawFileTest', () => {return new ArkuiXMakeFromRawFileTest();}],

      //path
      ['ArkuiXPathlineto', () => { return new ArkuiXPathLineTo(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathmoveto', () => { return new ArkuiXPathMoveTo(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPatharcto', () => { return new ArkuiXPathArcTo(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathquadto', () => { return new ArkuiXPathQuadTo(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathconicto', () => { return new ArkuiXPathConicTo(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathcubicto', () => { return new ArkuiXPathCubicTo(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathrmoveto', () => { return new ArkuiXPathRMoveTo(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathrlineto', () => { return new ArkuiXPathRLineTo(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathrquadto', () => { return new ArkuiXPathRQuadTo(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathrconicto', () => { return new ArkuiXPathRConicTo(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathrcubicto', () => { return new ArkuiXPathRCubicTo(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathaddpolygon', () => { return new ArkuiXPathAddPolygon(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathop', () => { return new ArkuiXPathOp(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathaddarc', () => { return new ArkuiXPathAddArc(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathaddcircle', () => { return new ArkuiXPathAddCircle(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathaddoval', () => { return new ArkuiXPathAddOval(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathaddrect', () => { return new ArkuiXPathAddRect(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathaddroundrect', () => { return new ArkuiXPathAddRoundRect(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathaddpath', () => { return new ArkuiXPathAddPath(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathcontains', () => { return new ArkuiXPathContains(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathtransform', () => { return new ArkuiXPathTransform(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathsetfilltype', () => { return new ArkuiXPathSetFillType(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathclose', () => { return new ArkuiXPathClose(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathoffset', () => { return new ArkuiXPathOffset(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathreset', () => { return new ArkuiXPathReset(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathgetlength', () => { return new ArkuiXPathGetLength(); }],
      ['ArkuiXPathdirection', () => { return new ArkuiXPathDirection(); }],
      ['ArkuiXPathgetpositionandtangent', () => { return new ArkuiXPathGetPositionAndTangent(); }],
      ['ArkuiXPathgetsegment', () => { return new ArkuiXPathGetSegment(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathconstruct', () => { return new ArkuiXPathConstructor(); }],
      ['ArkuiXPathgetbounds', () => { return new ArkuiXPathGetBounds(); }],
      ['ArkuiXPathgetpathiterator', () => { return new ArkuiXPathGetPathIterator(); }],
      ['ArkuiXPathgetmatrix', () => { return new ArkuiXPathGetMatrix(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathisclosed', () => { return new ArkuiXPathIsClosed(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathbuildfromsvgstring', () => { return new ArkuiXPathBuildFromSvgString(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathmeasurematrixflags', () => { return new ArkuiXPathMeasureMatrixFlags(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathSet', () => { return new ArkuiXPathSet(); }],
      ['ArkuiXPathSetLastPoint', () => { return new ArkuiXPathSetLastPoint(); }],
      ['ArkuiXPathGetFillType', () => { return new ArkuiXPathGetFillType(StyleType.DRAW_STYLE_NONE); }],
      ['ArkuiXPathReWindAndIsEmpty', () => { return new ArkuiXPathReWindAndIsEmpty(); }],
      ['ArkuiXPathIsRect', () => { return new ArkuiXPathIsRect(); }],
      ['ArkuiXPathApproximate', () => { return new ArkuiXPathApproximate(); }],
      ['ArkuiXPathInterpolate', () => { return new ArkuiXPathInterpolate(); }],
      ['ArkuiXPathIsInterpolate', () => { return new ArkuiXPathIsInterpolate(); }],

      //pathiterator
      ['ArkuiXPathiteratorconstructor', () => { return new ArkuiXPathIteratorConstructor(); }],
      ['ArkuiXPathiteratornext', () => { return new ArkuiXPathIteratorNext(); }],
      ['ArkuiXPathiteratorhasnext', () => { return new ArkuiXPathIteratorHasNext(); }],
      ['ArkuiXPathiteratorpeek', () => { return new ArkuiXPathIteratorPeek(); }],
      ['ArkuiXPathiteratorverb', () => { return new ArkuiXPathIteratorVerb(); }],

      //samplingoptions
      ['ArkuiXSamplingoptionstest', () => { return new ArkuiXSamplingOptionsTest(); }],

      //shadowflag
      ['ArkuiXShadowflagtest', () => { return new ArkuiXShadowFlagTest(); }],

      //pointmode
      ['ArkuiXPointmodetest', () => {return new ArkuiXPointModeTest();}],

      //typeArguments
      ['ArkuiXMakeFromCurrentTest', () => { return new ArkuiXMakeFromCurrentTest(); }],
      ['ArkuiXMakeFromFileWithArgumentsTest', () => { return new ArkuiXMakeFromFileWithArgumentsTest(); }],
      ['ArkuiXMakeFromRawFileWithArgumentsTest', () => {return new ArkuiXMakeFromRawFileWithArgumentsTest();}],

      //tool
      ['ArkuiXToolMakeColorFromResourceColorTest1', () => {return new ToolMakeColorFromResourceColorTest1();}],
      ['ArkuiXToolMakeColorFromResourceColorTest2', () => {return new ToolMakeColorFromResourceColorTest2();}],
      ['ArkuiXToolMakeColorFromResourceColorTest3', () => {return new ToolMakeColorFromResourceColorTest3();}],
      ['ArkuiXToolMakeColorFromResourceColorTest4', () => {return new ToolMakeColorFromResourceColorTest4();}],
    ]
  );

  static getArkuixAllCase(): Map<string, Function> {
    return this.ArkuixMap;
  }

  static getArkuixGpuCase(caseName: string): TestBase {
    let func:Function | undefined = this.ArkuixMap.get(caseName);
    if (func == undefined || func == null) {
      console.error(TAG, 'Testcase name is invalid');
      return null;
    }
    return func();
  }
}