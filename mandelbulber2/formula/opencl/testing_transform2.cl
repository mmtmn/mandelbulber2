/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Testing transform2
 *

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_testing_transform2.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TestingTransform2Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 p = z;
	REAL dd = aux->DE;
	REAL m = 0.0f;
	REAL tp = 1.0f;
	REAL4 signs = z;
	signs.x = sign(z.x);
	signs.y = sign(z.y);
	signs.z = sign(z.z);

	if (fractal->transformCommon.functionEnabledzFalse) z = fabs(z);

	if (aux->i >= fractal->transformCommon.startIterationsA
			&& aux->i < fractal->transformCommon.stopIterationsA)
		z -= fractal->transformCommon.offset000;



	REAL trr = dot(z, z);
	if (fractal->transformCommon.functionEnabledAFalse)
	{
		if (trr < fractal->transformCommon.scale1)
		{
			tp = min(1.0f / trr, fractal->transformCommon.scale4);
		}
		else
		{
			tp = fractal->transformCommon.scale1;
		}
	}


	if (fractal->transformCommon.functionEnabledCFalse)
	{
		tp = trr
				 + native_sin(trr * M_PI_F * fractal->transformCommon.scaleB1)
						 * fractal->transformCommon.scaleC1
				 + fractal->transformCommon.offset1;
		tp = min(max(1.0f / tp, fractal->transformCommon.scale1), fractal->transformCommon.scale4);
	}
	/*	if (trr < fractal->transformCommon.scale4)
		{
			tp = fractal->transformCommon.scale4 / fractal->transformCommon.scale1;
		}
		else if (trr < fractal->transformCommon.scale1)
		{
			tp = 1.0f / fractal->transformCommon.scale1 / trr;
		}
	}*/

	if (fractal->transformCommon.functionEnabledJFalse)
	{
		tp = min(max(1.0f / trr, fractal->transformCommon.scale1), fractal->transformCommon.scale4);
	}

	if (fractal->transformCommon.functionEnabledMFalse)
	{
		tp = 1.0f / trr + fractal->transformCommon.scale1;
		tp = min(tp, fractal->transformCommon.scale4);
	}

	if (aux->i >= fractal->transformCommon.startIterationsA
			&& aux->i < fractal->transformCommon.stopIterationsA)
		z += fractal->transformCommon.offset000;

	z *= tp;
	aux->DE *= tp;
	if (fractal->transformCommon.functionEnabledSFalse) z *= signs;

	if (fractal->transformCommon.functionEnabledBFalse
			&& aux->i >= fractal->transformCommon.startIterationsB
			&& aux->i < fractal->transformCommon.stopIterationsB)
	{
		REAL rr = dot(p, p);
		if (rr < 1.0f)
		{
			p += fractal->mandelbox.offset;
			if (rr < fractal->transformCommon.scale025)
				m = fractal->transformCommon.scale025;
			else
				m = rr;
			m = 1.0f / m;
			p *= m;
			dd *= m;
			p -= fractal->mandelbox.offset;
		}

		z = p + (z - p) * fractal->transformCommon.scaleA1;
		aux->DE = dd + (aux->DE - dd) * fractal->transformCommon.scaleA1;
	}
	if (fractal->foldColor.auxColorEnabledFalse)
	{
		aux->color += tp * fractal->mandelbox.color.factorSp1;
		aux->color += m * fractal->mandelbox.color.factorSp2;
	}

	// DE tweak
	if (fractal->analyticDE.enabledFalse)
		aux->DE = aux->DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;
	return z;
}
