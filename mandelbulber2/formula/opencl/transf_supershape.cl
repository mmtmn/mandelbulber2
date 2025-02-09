/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Adds c constant to z vector
 * This formula contains aux.pos_neg

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_add_norm.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfSupershapeIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL r1 = sqrt(z.x * z.x + z.y * z.y);
	REAL tho = asin(z.z / r1);
	REAL phi;

	if (!fractal->transformCommon.functionEnabledAFalse) phi = atan2(z.y, z.x);
	else phi = atan2(z.x, z.y);

	REAL t1 = fabs(cos(fractal->transformCommon.constantMultiplierA111.x * phi)
			* fractal->transformCommon.constantMultiplierA111.y);
	if (fractal->transformCommon.functionEnabledXFalse)
		t1 = pow(t1, fractal->transformCommon.constantMultiplierB111.x);

	REAL t2 = fabs(sin(fractal->transformCommon.constantMultiplierA111.x * phi)
			* fractal->transformCommon.constantMultiplierA111.z);

	if (fractal->transformCommon.functionEnabledYFalse)
		t2 = pow(t2, fractal->transformCommon.constantMultiplierB111.y);

	if (!fractal->transformCommon.functionEnabledEFalse) r1 = t1 + t2;
	else r1 = pow(t1 + t2, -fractal->transformCommon.constantMultiplierB111.z);

	if (!fractal->transformCommon.functionEnabledFFalse)
		r1 = 1.0f / r1;


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
		REAL cth = cos(tho);

			z.x = cth * cos(phi);
			z.y = cth * sin(phi);
			z.z = sin(tho);
			z *= r1;

	}


	if (fractal->analyticDE.enabledFalse)
		aux->DE =
			aux->DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;

	if (fractal->transformCommon.functionEnabledKFalse)
	{
		REAL4 zc = z;
		REAL T1;
		if (!fractal->transformCommon.functionEnabledIFalse)
			T1 = length(zc);
		else
		{
			if (fractal->transformCommon.functionEnabledJFalse) zc = fabs(zc);
			T1 = max(max(zc.x, zc.y), zc.z);
		}

		T1 = T1 / (aux->DE + fractal->transformCommon.offset0) - fractal->transformCommon.offset01;
		aux->dist = min(T1, aux->dist);

		if (fractal->transformCommon.functionEnabledZcFalse) z = zc;
	}

	return z;
}
