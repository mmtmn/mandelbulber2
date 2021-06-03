/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Based on a DarkBeam fold formula adapted by Knighty
 * MandalayBox  Fragmentarium /Examples/ Knighty Collection

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_testing_transform.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TestingTransformIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 lpN = fabs(z);
	REAL pr = fractal->transformCommon.scale2;
	lpN.x = native_powr(lpN.x, pr);
	lpN.y = native_powr(lpN.y, pr);
	lpN.z = native_powr(lpN.z, pr);

	REAL pNorm = lpN.x + lpN.y + lpN.z;
	if (fractal->transformCommon.functionEnabledFalse) pNorm += native_powr(lpN.w, pr);
	pNorm = native_powr(pNorm, 1.0 / pr);

	pNorm = native_powr(pNorm, fractal->transformCommon.scaleA2);
	pNorm = max(pNorm, fractal->transformCommon.offset0);

	REAL useScale = fractal->transformCommon.scale1 - aux->actualScaleA;
	if (fractal->transformCommon.functionEnabledKFalse) // update actualScaleA
		aux->actualScaleA = fractal->transformCommon.scaleVary0 * (fabs(aux->actualScaleA) + 1.0f);
	pNorm = useScale / pNorm;
	z *= pNorm;
	aux->DE *= fabs(pNorm);

	return z;
}
