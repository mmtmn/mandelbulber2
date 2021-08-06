/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2021 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * TransfDifsTorusV2Iteration  fragmentarium code, mdifs by knighty (jan 2012)
 * and http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_difs_torus_v2.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfDIFSTorusV2Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	z += fractal->transformCommon.offset000;

	if (fractal->transformCommon.functionEnabledxFalse) z.x = -fabs(z.x);
	if (fractal->transformCommon.functionEnabledyFalse) z.y = -fabs(z.y);
	if (fractal->transformCommon.functionEnabledzFalse) z.z = -fabs(z.z);

	if (fractal->transformCommon.rotationEnabledFalse
			&& aux->i >= fractal->transformCommon.startIterationsR
			&& aux->i < fractal->transformCommon.stopIterationsR1)
	{
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
	}

	REAL4 zc = z;
	REAL torD;
	REAL lenX = 0.0f;
	REAL lenY = 0.0f;

	// swap axis
	if (fractal->transformCommon.functionEnabledSwFalse)
	{
		REAL temp = zc.x;
		zc.x = zc.z;
		zc.z = temp;
	}
	if (fractal->transformCommon.functionEnabledSFalse)
	{
		REAL temp = zc.y;
		zc.y = zc.z;
		zc.z = temp;
	}

	REAL4 absZ = fabs(zc);
	if (fractal->transformCommon.functionEnabledMFalse)
		lenX = absZ.z * fractal->transformCommon.scale0;
	if (fractal->transformCommon.functionEnabledNFalse)
		lenY = absZ.z * fractal->transformCommon.scaleA0;

	REAL3 q = (REAL3){max(absZ.y - lenY, 0.0f), max(absZ.x - lenX, 0.0f), zc.z};
	q *= q;

	torD = native_sqrt(q.y + q.x) - fractal->transformCommon.offsetT1;

	if (!fractal->transformCommon.functionEnabledJFalse)
		torD = native_sqrt(torD * torD + q.z);
	else
		torD = max(fabs(torD), fabs(zc.z));

	aux->dist = min(aux->dist, (torD - fractal->transformCommon.offset05) / (aux->DE + 1.0f));
	aux->DE0 = (torD - fractal->transformCommon.offset05); // temp testing
	return z;
}