﻿/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Pseudo Kleinian Knighty - Theli-at's Pseudo Kleinian (Scale 1 JuliaBox + Something
 * @reference https://github.com/Syntopia/Fragmentarium/blob/master/
 * Fragmentarium-Source/Examples/Knighty%20Collection/PseudoKleinian.frag

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_pseudo_kleinian.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 PseudoKleinianIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	// sphere inversion slot#1 iter == 0 added v2.17
	if (fractal->transformCommon.sphereInversionEnabledFalse)
	{
		if (aux->i < 1)
		{
			REAL rr = 1.0f;
			z += fractal->transformCommon.offset000;
			rr = dot(z, z);
			z *= fractal->transformCommon.maxR2d1 / rr;
			z += fractal->transformCommon.additionConstantA000 - fractal->transformCommon.offset000;
			// REAL r = native_sqrt(rr);
			aux->DE = aux->DE * (fractal->transformCommon.maxR2d1 / rr) + fractal->analyticDE.offset0;
		}
	}

	REAL4 gap = fractal->transformCommon.constantMultiplier000;
	REAL t;
	REAL dot1;
	// prism shape
	if (fractal->transformCommon.functionEnabledPFalse
			&& aux->i >= fractal->transformCommon.startIterationsP
			&& aux->i < fractal->transformCommon.stopIterationsP1)
	{
		z.y = fabs(z.y);
		z.z = fabs(z.z);
		dot1 = (z.x * -SQRT_3_4_F + z.y * 0.5f) * fractal->transformCommon.scale;
		t = max(0.0f, dot1);
		z.x -= t * -SQRT_3_F;
		z.y = fabs(z.y - t);

		if (z.y > z.z)
		{
			REAL temp = z.y;
			z.y = z.z;
			z.z = temp;
		}
		z -= gap * (REAL4){SQRT_3_4_F, 1.5f, 1.5f, 0.0f};
		// z was pos, now some points neg (ie neg shift)
		if (z.z > z.x)
		{
			REAL temp = z.z;
			z.z = z.x;
			z.x = temp;
		}
		if (z.x > 0.0f)
		{
			z.y = max(0.0f, z.y);
			z.z = max(0.0f, z.z);
		}
	}

	// box fold abs() tglad fold added v2.17
	if (fractal->transformCommon.functionEnabledByFalse
			&& aux->i >= fractal->transformCommon.startIterationsE
			&& aux->i < fractal->transformCommon.stopIterationsE)
	{
		z.x = fabs(z.x + fractal->transformCommon.additionConstant111.x)
					- fabs(z.x - fractal->transformCommon.additionConstant111.x) - z.x;
		z.y = fabs(z.y + fractal->transformCommon.additionConstant111.y)
					- fabs(z.y - fractal->transformCommon.additionConstant111.y) - z.y;
		if (fractal->transformCommon.functionEnabledBy)
		{
			z.z = fabs(z.z + fractal->transformCommon.additionConstant111.z)
						- fabs(z.z - fractal->transformCommon.additionConstant111.z) - z.z;
		}
	}

	// box fold
	if (fractal->transformCommon.functionEnabledBxFalse
			&& aux->i >= fractal->transformCommon.startIterationsA
			&& aux->i < fractal->transformCommon.stopIterationsA)
	{
		if (fabs(z.x) > fractal->mandelbox.foldingLimit)
		{
			z.x = sign(z.x) * fractal->mandelbox.foldingValue - z.x;
			aux->color += fractal->mandelbox.color.factor.x;
		}
		if (fabs(z.y) > fractal->mandelbox.foldingLimit)
		{
			z.y = sign(z.y) * fractal->mandelbox.foldingValue - z.y;
			aux->color += fractal->mandelbox.color.factor.y;
		}
		REAL zLimit = fractal->mandelbox.foldingLimit * fractal->transformCommon.scale1;
		REAL zValue = fractal->mandelbox.foldingValue * fractal->transformCommon.scale1;
		if (fabs(z.z) > zLimit)
		{
			z.z = sign(z.z) * zValue - z.z;
			aux->color += fractal->mandelbox.color.factor.z;
		}
	}
	// PseudoKleinian
	z = fabs(z + fractal->transformCommon.additionConstant0777)
			- fabs(z - fractal->transformCommon.additionConstant0777) - z;
	REAL k = max(fractal->transformCommon.minR05 / dot(z, z), 1.0f);
	z *= k;
	aux->DE *= k + fractal->analyticDE.tweak005;
	// rotation
	if (fractal->transformCommon.functionEnabledRFalse
			&& aux->i >= fractal->transformCommon.startIterationsR
			&& aux->i < fractal->transformCommon.stopIterationsR)
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
	// offset
	z += fractal->transformCommon.additionConstant000;

	aux->pseudoKleinianDE = fractal->analyticDE.scale1;
	return z;
}
