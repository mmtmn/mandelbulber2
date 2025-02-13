/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2022 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * t

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_testing_log.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 NewtonPow3Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	// abs()
	if (fractal->transformCommon.functionEnabledAFalse)
	{
		if (fractal->transformCommon.functionEnabledAxFalse) z.x = fabs(z.x);
		if (fractal->transformCommon.functionEnabledAyFalse) z.y = fabs(z.y);
		if (fractal->transformCommon.functionEnabledAzFalse) z.z = fabs(z.z);
	}
	// Preparation operations
	REAL fac_eff = 0.6666666666f;

	// Converting the diverging (x,y,z) back to the variable
	// that can be used for the (converging) Newton method calculation
	REAL sq_r = fractal->transformCommon.scaleA1 / (aux->r * aux->r);

	z.x = z.x * sq_r + 1.0f;
	z.y = -z.y * sq_r;
	z.z = -z.z * sq_r;

	// Calculate the inverse power of t=(x,y,z),
	// and use it for the Newton method calculations for t^power + c = 0
	// i.e. t(n+1) = 2*t(n)/3 - c/2*t(n)^2
	REAL4 tp = z * z;
	sq_r = tp.x + tp.y + tp.z; // dot
	sq_r = 1.0f / (3.0f * sq_r * sq_r);

	REAL r_xy = tp.x + tp.y;
	REAL h1 = 1.0f - tp.z / r_xy;

	REAL tmpx = h1 * (tp.x - tp.y) * sq_r;
	REAL tmpy = -2.0f * h1 * z.x * z.y * sq_r;
	REAL tmpz = 2.0f * z.z * native_sqrt(r_xy) * sq_r;

	tp.x = -tmpx;
	tp.y = -tmpy;
	tp.z = tmpz;

	z = fac_eff * z - tp;

	// Below the hack that provides a divergent value of (x,y,z) to Mandelbulber
	// although the plain Newton method does always converge
	tp.x = z.x - 1.0f;
	tp.y = z.y;
	tp.z = z.z;

	sq_r = fractal->transformCommon.scaleB1 / dot(tp, tp);
	z.x = tp.x * sq_r;
	z.y = -tp.y * sq_r;
	z.z = -tp.z * sq_r;

	z += fractal->transformCommon.offset000;

	aux->DE *= aux->r * 2.0f;
	if (fractal->analyticDE.enabledFalse)
	{
		aux->DE = aux->DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset1;
	}

	if (fractal->transformCommon.functionEnabledOFalse)
	{
		REAL4 q = z;
		q.x -= fractal->transformCommon.offsetA1;
		REAL r = (length(q) + fractal->transformCommon.offsetA1);

		if (!fractal->transformCommon.functionEnabledYFalse)
			aux->dist = min(aux->dist, 0.5f * log(r) * r / aux->DE);
		else
			aux->dist = 0.5f * log(r) * r / aux->DE;
	}
	return z;
}
