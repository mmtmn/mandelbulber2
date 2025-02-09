﻿/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.         ______
 * Copyright (C) 2019 Mandelbulber Team   _>]|=||i=i<,      / ____/ __    __
 *                                        \><||i|=>>%)     / /   __/ /___/ /_
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    / /__ /_  __/_  __/
 * The project is licensed under GPLv3,   -<>>=|><|||`    \____/ /_/   /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Mandelbulb fractal.
 * @reference http://www.fractalforums.com/3d-fractal-generation/true-3d-mandlebrot-type-fractal/
 */

#include "all_fractal_definitions.h"

cFractalMandelbulbSinCosV3::cFractalMandelbulbSinCosV3() : cAbstractFractal()
{
	nameInComboBox = "Mandelbulb Sin Cos V3";
	internalName = "mandelbulb_sin_cos_v3";
	internalID = fractal::mandelbulbSinCosV3;
	DEType = analyticDEType;
	DEFunctionType = logarithmicDEFunction;
	cpixelAddition = cpixelDisabledByDefault;
	defaultBailout = 10.0;
	DEAnalyticFunction = analyticFunctionLogarithmic;
	coloringFunction = coloringFunctionDefault;
}

void cFractalMandelbulbSinCosV3::FormulaCode(CVector4 &z, const sFractal *fractal, sExtendedAux &aux)
{

	double r1 = 0.0;
	if (aux.i >= fractal->transformCommon.startIterations
		&& aux.i < fractal->transformCommon.stopIterations1)
	{

		r1 = sqrt(z.x * z.x + z.y * z.y);
		double tho = asin(z.z / r1);
		double phi;
		if (!fractal->transformCommon.functionEnabledSwFalse)
			phi = atan2(z.y, z.x);
		else
			phi = atan2(z.x, z.y);

		double t1;
		double t2;
		t1 = cos(fractal->transformCommon.constantMultiplierA111.x * phi)
				 / fractal->transformCommon.constantMultiplierA111.y;
		t1 = fabs(t1);
		t1 = pow(t1, fractal->transformCommon.constantMultiplierB111.x);
		t2 = sin(fractal->transformCommon.constantMultiplierA111.x * phi)
				 / fractal->transformCommon.constantMultiplierA111.z;
		t2 = fabs(t2);
		t2 = pow(t2, fractal->transformCommon.constantMultiplierB111.y);
		r1 = pow(t1 + t2, -1 / fractal->transformCommon.constantMultiplierB111.z);
		if (fractal->transformCommon.functionEnabledRFalse) r1 = 1 / r1;

	}
	//
	aux.r = aux.r + r1 * fractal->transformCommon.radius1;
	// aux.r = aux.r + (r1 - aux.r)* fractal->transformCommon.radius1;

	double th = z.z / aux.r;
	if (!fractal->transformCommon.functionEnabledBFalse)
	{
		if (!fractal->transformCommon.functionEnabledAFalse) th = asin(th);
		else th = acos(th);
	}
	else
	{
		th = acos(th) * (1.0 - fractal->transformCommon.scale1)
				+ asin(th) * fractal->transformCommon.scale1;
	}
	double ph;
	if (!fractal->transformCommon.functionEnabledXFalse)
		ph = atan2(z.y, z.x);
	else
		ph = atan2(z.x, z.y);

	th = (th + fractal->bulb.betaAngleOffset) * fractal->bulb.power;
	ph = (ph + fractal->bulb.alphaAngleOffset) * fractal->bulb.power;
	double rp = pow(aux.r, fractal->bulb.power - 1.0);
	aux.DE = rp * aux.DE * fractal->bulb.power + 1.0;
	rp *= aux.r;

	// polar to cartesian
	if (fractal->transformCommon.functionEnabledAx
			&& aux.i >= fractal->transformCommon.startIterationsT
			&& aux.i < fractal->transformCommon.stopIterationsT)
	{
		if (!fractal->transformCommon.functionEnabledEFalse)
		{
			double cth = cos(th);
			if (!fractal->transformCommon.functionEnabledDFalse)
			{
				z.x = cth * cos(ph);
				z.y = cth * sin(ph);
				z.z = sin(th);
			}
			else
			{
				z.x = cth * cos(ph);
				z.y = sin(th);
				z.z = cth * sin(ph);
			}
		}
		else
		{
			double sth = sin(th);
			if (!fractal->transformCommon.functionEnabledDFalse)
			{
				z.x = sth * sin(ph);
				z.y = sth * cos(ph);
				z.z = cos(th);
			}
			else
			{
				z.x = sth * sin(ph);
				z.y = cos(th);
				z.z = sth * cos(ph);
			}
		}
		z *= rp;
	}

	if (fractal->transformCommon.functionEnabledGFalse
			&& aux.i >= fractal->transformCommon.startIterationsG
			&& aux.i < fractal->transformCommon.stopIterationsG)
	{
		double sth = sin(th);
		z.x = z.x + (rp * sth * sin(ph) - z.x) * fractal->transformCommon.scaleC1;
		z.y = z.y + (rp * sth * cos(ph) - z.y) * fractal->transformCommon.scaleF1;
		if (!fractal->transformCommon.functionEnabledFFalse)
			z.z = rp * cos(th);
		else
			z.z = sth;


		/*double cth = cos(th);
		z.x = z.x + (cth * cos(ph) - z.x) * fractal->transformCommon.scaleC1;
		z.y = z.y + (cth * sin(ph) - z.y) * fractal->transformCommon.scaleF1;
		if (!fractal->transformCommon.functionEnabledFFalse)
			z.z = sin(th);
		else
			z.z = cth;*/
	}

	if (fractal->transformCommon.functionEnabledJFalse
			&& aux.i >= fractal->transformCommon.startIterationsJ
			&& aux.i < fractal->transformCommon.stopIterationsJ)
	{
		double cth = cos(th);
		z.x = sin(ph);
		z.y = cos(ph);
		z.z = sin(th);
		if (fractal->transformCommon.functionEnabledKFalse) z.x *= cth;
		if (fractal->transformCommon.functionEnabledMFalse) z.y *= cth;
		if (fractal->transformCommon.functionEnabledNFalse) z.z *= cth;
		z *= rp;
	}



	z += fractal->transformCommon.offsetA000;
	z += aux.const_c * fractal->transformCommon.constantMultiplier111;
	z.z *= fractal->transformCommon.scaleA1;

/*	if (fractal->transformCommon.functionEnabledPFalse
			&& aux.i >= fractal->transformCommon.startIterationsP
			&& aux.i < fractal->transformCommon.stopIterationsP)
	{
		//  supershape

		double r = sqrt(z.x * z.x + z.y * z.y);
		double t1 = 0.0;
		double t2 = 0.0;
		double m = fractal->transformCommon.scale3D111.x, a = fractal->transformCommon.intA1,
				 b = fractal->transformCommon.intB1, n1 = fractal->transformCommon.int1,
				 n2 = fractal->transformCommon.scale3D111.y, n3 = fractal->transformCommon.scale3D111.z;
		double tho = asin(z.z / r);
		double phi = atan2(z.y, z.x);
		t1 = cos(m * phi) / a;// hmmmm??
		t1 = fabs(t1);
			t1 = pow(t1, n2);

		t2 = sin(m * phi) / b;// hmmmm??
		t2 = fabs(t2);
			t2 = pow(t2, n3);

		r = pow(t1 + t2, -fractal->transformCommon.scaleB1 / n1);
		r = 1 / r;

		if (fractal->transformCommon.functionEnabledAzFalse)
		{
			if (fractal->transformCommon.functionEnabledAxFalse)
			{
				if (fabs(z.x) > fabs(z.y)) z.y = r * sin(phi);
				else z.y = r * cos(phi);
			}
			if (fractal->transformCommon.functionEnabledAyFalse)
			{
				if (fabs(z.x) < fabs(z.y)) z.y = r * cos(phi);
				else z.y = r * sin(phi);
			}
			if (fractal->transformCommon.functionEnabledBxFalse) z.y = r * sin(phi);
			if (fractal->transformCommon.functionEnabledByFalse) z.y = r * cos(phi);
		}

		if (fractal->transformCommon.functionEnabledBzFalse)
		{
			if (fractal->transformCommon.functionEnabledAxFalse)
			{
				if (fabs(z.x) > fabs(z.y)) z.x = r * sin(phi);
				else z.x = r * cos(phi);
			}
			if (fractal->transformCommon.functionEnabledAyFalse)
			{
				if (fabs(z.x) < fabs(z.y)) z.x = r * cos(phi);
				else z.x = r * sin(phi);
			}
			if (fractal->transformCommon.functionEnabledBxFalse) z.x = r * sin(phi);
			if (fractal->transformCommon.functionEnabledByFalse) z.x = r * cos(phi);
		}

	}*/




	if (fractal->analyticDE.enabledFalse)
	{
		aux.DE = aux.DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;
	}

	if (fractal->transformCommon.functionEnabledCFalse)
	{
		aux.DE0 = z.Length();
		if (aux.DE0 > 1.0)
			aux.DE0 = 0.5 * log(aux.DE0) * aux.DE0 / (aux.DE);
		else
			aux.DE0 = 0.01; // 0.0 artifacts in openCL

		if (aux.i >= fractal->transformCommon.startIterationsO
					&& aux.i < fractal->transformCommon.stopIterationsO)
			aux.dist = min(aux.dist, aux.DE0);
		else
			aux.dist = aux.DE0;
	}
}
