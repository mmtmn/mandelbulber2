/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.         ______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,      / ____/ __    __
 *                                        \><||i|=>>%)     / /   __/ /___/ /_
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    / /__ /_  __/_  __/
 * The project is licensed under GPLv3,   -<>>=|><|||`    \____/ /_/   /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * superformula Johan Gielis
 * https://bsapubs.onlinelibrary.wiley.com/doi/10.3732/ajb.90.3.333
 * http://paulbourke.net/geometry/supershape/
 */

#include "all_fractal_definitions.h"

cFractalTransfSupershape::cFractalTransfSupershape() : cAbstractFractal()
{
	nameInComboBox = "T>Supershape";
	internalName = "transf_supershape";
	internalID = fractal::transfSupershape;
	DEType = analyticDEType;
	DEFunctionType = withoutDEFunction;
	cpixelAddition = cpixelDisabledByDefault;
	defaultBailout = 100.0;
	DEAnalyticFunction = analyticFunctionNone;
	coloringFunction = coloringFunctionDefault;
}

void cFractalTransfSupershape::FormulaCode(
	CVector4 &z, const sFractal *fractal, sExtendedAux &aux)
{
	double r1 = sqrt(z.x * z.x + z.y * z.y);
	double tho = asin(z.z / r1); // mmmmmmmmmmmmmmmm
	double phi;

	if (!fractal->transformCommon.functionEnabledAFalse) phi = atan2(z.y, z.x);
	else phi = atan2(z.x, z.y);

	double t1 = fabs(cos(fractal->transformCommon.constantMultiplierA111.x * phi)
			* fractal->transformCommon.constantMultiplierA111.y);
	if (fractal->transformCommon.functionEnabledXFalse)
		t1 = pow(t1, fractal->transformCommon.constantMultiplierB111.x);

	double t2 = fabs(sin(fractal->transformCommon.constantMultiplierA111.x * phi)
			* fractal->transformCommon.constantMultiplierA111.z);

	if (fractal->transformCommon.functionEnabledYFalse)
		t2 = pow(t2, fractal->transformCommon.constantMultiplierB111.y);

	if (!fractal->transformCommon.functionEnabledEFalse) r1 = t1 + t2;
	else r1 = pow(t1 + t2, -fractal->transformCommon.constantMultiplierB111.z);

	if (!fractal->transformCommon.functionEnabledFFalse)
		r1 = 1.0 / r1;

	//if (fractal->transformCommon.functionEnabledBFalse)
	//	aux.DE0 = r;

	if (fractal->transformCommon.functionEnabledxFalse)
	{
		if (!fractal->transformCommon.functionEnabledAxFalse)
			z.x = r1 * sin(phi);
		else
			z.x = r1 * cos(phi);
	}

	if (fractal->transformCommon.functionEnabledyFalse)
	{
		if (!fractal->transformCommon.functionEnabledAyFalse)
			z.y = r1 * sin(phi);
		else
			z.y = r1 * cos(phi);
	}

	if (fractal->transformCommon.functionEnabledzFalse)
	{
		if (!fractal->transformCommon.functionEnabledAzFalse)
			z.z = r1 * sin(phi);
		else
			z.z = r1 * cos(phi);
	}

	if (fractal->transformCommon.functionEnabledCFalse)
	{
		double cth = cos(tho);

			z.x = cth * cos(phi);
			z.y = cth * sin(phi);
			z.z = sin(tho);
			z *= r1;

	}

	if (fractal->analyticDE.enabledFalse)
		aux.DE = aux.DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;

	if (fractal->transformCommon.functionEnabledKFalse)
	{
		CVector4 zc = z;
		double T1;
		if (!fractal->transformCommon.functionEnabledIFalse)
			T1 = zc.Length();
		else
		{
			if (fractal->transformCommon.functionEnabledJFalse) zc = fabs(zc);
			T1 = max(max(zc.x, zc.y), zc.z);
		}

		T1 = T1 / (aux.DE + fractal->transformCommon.offset0) - fractal->transformCommon.offset01;
		aux.dist = min(T1, aux.dist);

		if (fractal->transformCommon.functionEnabledZcFalse) z = zc;
	}

}
