/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * MsltoeJuliaBulb Eiffie. Refer post by Eiffie    Reply #69 on: January 27, 2015
 * @reference http://www.fractalforums.com/theory/choosing-the-squaring-formula-by-location/60/

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_eiffie_msltoe.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 MsltoeSym3Mod4Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 c = aux->const_c;

	aux->DE = aux->DE * 2.0f * aux->r;
	REAL psi = M_PI_F / fractal->transformCommon.int8Y;

	psi = fabs(fmod(atan2(z.z, z.y) + M_PI_F + psi, 2.0f * psi) - psi);
	REAL lengthYZ = native_sqrt(z.y * z.y + z.z * z.z);
	z.y = native_cos(psi) * lengthYZ;
	z.z = native_sin(psi) * lengthYZ;

	REAL4 z2 = z * z;
	REAL rr = z2.x + z2.y + z2.z;
	REAL m = 1.0f - z2.z / rr;
	REAL4 temp;
	temp.x = (z2.x - z2.y) * m;
	temp.y = 2.0f * z.x * z.y * m * fractal->transformCommon.scale; // scaling y;
	temp.z = 2.0f * z.z * native_sqrt(z2.x + z2.y);
	temp.w = z.w;
	z = temp + fractal->transformCommon.additionConstantNeg100;

	if (fractal->transformCommon.addCpixelEnabledFalse)
	{
		REAL4 tempFAB = c;
		if (fractal->transformCommon.functionEnabledx) tempFAB.x = fabs(tempFAB.x);
		if (fractal->transformCommon.functionEnabledy) tempFAB.y = fabs(tempFAB.y);
		if (fractal->transformCommon.functionEnabledz) tempFAB.z = fabs(tempFAB.z);

		tempFAB *= fractal->transformCommon.constantMultiplier000;
		z.x += sign(z.x) * tempFAB.x;
		z.y += sign(z.y) * tempFAB.y;
		z.z += sign(z.z) * tempFAB.z;
	}

	REAL lengthTempZ = -length(z);
	// if (lengthTempZ > -1e-21f) lengthTempZ = -1e-21f; // z is neg.)
	z *= 1.0f + fractal->transformCommon.offset / lengthTempZ;
	z *= fractal->transformCommon.scale1;

	if (fractal->transformCommon.functionEnabledFalse // quaternion fold
			&& aux->i >= fractal->transformCommon.startIterationsA
			&& aux->i < fractal->transformCommon.stopIterationsA)
	{
		aux->r = length(z);
		aux->DE = aux->DE * 2.0f * aux->r;
		z = (REAL4){z.x * z.x - z.y * z.y - z.z * z.z, z.x * z.y, z.x * z.z, z.w};
		if (!fractal->analyticDE.enabled)
		{
			z *= (REAL4){1.0f, 2.0f, 2.0f, 1.0f};
		}
		else
		{
			REAL4 temp = z;
			REAL tempL = length(temp);
			z *= (REAL4){1.0f, 2.0f, 2.0f, 1.0f};
			// if (tempL < 1e-21f)
			//	tempL = 1e-21f;
			REAL avgScale = length(z) / tempL;
			aux->DE *= avgScale;
		}
	}

	if (!fractal->analyticDE.enabledFalse)
		aux->DE = aux->DE * fabs(fractal->transformCommon.scale1) + 1.0f;
	else
		aux->DE = aux->DE * fabs(fractal->transformCommon.scale1) * fractal->analyticDE.scale1
							+ fractal->analyticDE.offset0;
	return z;
}
