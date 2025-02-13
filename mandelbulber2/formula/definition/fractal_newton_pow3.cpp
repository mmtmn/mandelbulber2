/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.         ______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,      / ____/ __    __
 *                                        \><||i|=>>%)     / /   __/ /___/ /_
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    / /__ /_  __/_  __/
 * The project is licensed under GPLv3,   -<>>=|><|||`    \____/ /_/   /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * 3D pow3 bulb by gannjondal
 * refrence:
 * https://fractalforums.org/fractal-mathematics-and-new-theories/28/revisiting-the-3d-newton/1026
 */

#include "all_fractal_definitions.h"

cFractalNewtonPow3::cFractalNewtonPow3() : cAbstractFractal()
{
	nameInComboBox = "Newton Pow3";
	internalName = "newton_pow3";
	internalID = fractal::newtonPow3;
	DEType = deltaDEType;
	DEFunctionType = logarithmicDEFunction;
	cpixelAddition = cpixelDisabledByDefault;
	defaultBailout = 10.0;
	DEAnalyticFunction = analyticFunctionLogarithmic;
	coloringFunction = coloringFunctionDefault;
}

void cFractalNewtonPow3::FormulaCode(CVector4 &z, const sFractal *fractal, sExtendedAux &aux)
{
	// abs()
	if (fractal->transformCommon.functionEnabledAFalse)
	{
		if (fractal->transformCommon.functionEnabledAxFalse) z.x = fabs(z.x);
		if (fractal->transformCommon.functionEnabledAyFalse) z.y = fabs(z.y);
		if (fractal->transformCommon.functionEnabledAzFalse) z.z = fabs(z.z);
	}
	// Preparation operations
	double fac_eff = 0.6666666666;

	// Converting the diverging (x,y,z) back to the variable
	// that can be used for the (converging) Newton method calculation
	double sq_r = fractal->transformCommon.scaleA1 / (aux.r * aux.r);
	//aux.DE *= (sq_r);
	z.x = z.x * sq_r + 1.0;
	z.y = -z.y * sq_r; // 0.0
	z.z = -z.z * sq_r; // 0.0

	// Calculate the inverse power of t=(x,y,z),
	// and use it for the Newton method calculations for t^power + c = 0
	// i.e. t(n+1) = 2*t(n)/3 - c/2*t(n)^2
	CVector4 tp = z * z;
	sq_r = tp.x + tp.y + tp.z; // dot
	sq_r = 1.0 / (3.0 * sq_r * sq_r);

	double r_xy = tp.x + tp.y;
	double h1 = 1.0 - tp.z / r_xy;

	double tmpx = h1 * (tp.x - tp.y) * sq_r;
	double tmpy = -2.0 * h1 * z.x * z.y * sq_r;
	double tmpz = 2.0 * z.z * sqrt(r_xy) * sq_r;

	tp.x = -tmpx;
	tp.y = -tmpy;
	tp.z = tmpz;

	z = fac_eff * z - tp;

	// Below the hack that provides a divergent value of (x,y,z) to Mandelbulber
	// although the plain Newton method does always converge
	tp.x = z.x - 1.0;
	tp.y = z.y;
	tp.z = z.z;
	sq_r = fractal->transformCommon.scaleB1 / tp.Dot(tp);
	z.x = tp.x * sq_r;
	z.y = -tp.y * sq_r;
	z.z = -tp.z * sq_r;

	z += fractal->transformCommon.offset000;

	aux.DE *= aux.r * 2.0;
	if (fractal->analyticDE.enabledFalse)
	{
		aux.DE = aux.DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset1;
	}

	if (fractal->transformCommon.functionEnabledOFalse)
	{
		CVector4 q = z;
		q.x -= fractal->transformCommon.offsetA1;
		double r = q.Length() + fractal->transformCommon.offsetA1;

		if (!fractal->transformCommon.functionEnabledYFalse)
			aux.dist = min(aux.dist, 0.5f * log(r) * r / aux.DE);
		else
			aux.dist = 0.5f * log(r) * r / aux.DE;
	}
}
