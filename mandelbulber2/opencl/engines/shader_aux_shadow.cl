/**
 * Mandelbulber v2, a 3D fractal generator       ,=#MKNmMMKmmßMNWy,
 *                                             ,B" ]L,,p%%%,,,§;, "K
 * Copyright (C) 2018-21 Mandelbulber Team     §R-==%w["'~5]m%=L.=~5N
 *                                        ,=mm=§M ]=4 yJKA"/-Nsaj  "Bw,==,,
 * This file is part of Mandelbulber.    §R.r= jw",M  Km .mM  FW ",§=ß., ,TN
 *                                     ,4R =%["w[N=7]J '"5=],""]]M,w,-; T=]M
 * Mandelbulber is free software:     §R.ß~-Q/M=,=5"v"]=Qf,'§"M= =,M.§ Rz]M"Kw
 * you can redistribute it and/or     §w "xDY.J ' -"m=====WeC=\ ""%""y=%"]"" §
 * modify it under the terms of the    "§M=M =D=4"N #"%==A%p M§ M6  R' #"=~.4M
 * GNU General Public License as        §W =, ][T"]C  §  § '§ e===~ U  !§[Z ]N
 * published by the                    4M",,Jm=,"=e~  §  §  j]]""N  BmM"py=ßM
 * Free Software Foundation,          ]§ T,M=& 'YmMMpM9MMM%=w=,,=MT]M m§;'§,
 * either version 3 of the License,    TWw [.j"5=~N[=§%=%W,T ]R,"=="Y[LFT ]N
 * or (at your option)                   TW=,-#"%=;[  =Q:["V""  ],,M.m == ]N
 * any later version.                      J§"mr"] ,=,," =="""J]= M"M"]==ß"
 *                                          §= "=C=4 §"eM "=B:m|4"]#F,§~
 * Mandelbulber is distributed in            "9w=,,]w em%wJ '"~" ,=,,ß"
 * the hope that it will be useful,                 . "K=  ,=RMMMßM"""
 * but WITHOUT ANY WARRANTY;                            .'''
 * without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 * See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with Mandelbulber. If not, see <http://www.gnu.org/licenses/>.
 *
 * ###########################################################################
 *
 * Authors: Krzysztof Marczak (buddhi1980@gmail.com)
 *
 * calculation of shadows from auxiliary light sources
 */

#ifdef AUX_LIGHTS
#if defined(SHADOWS) || defined(VOLUMETRIC_LIGHTS)
float3 AuxShadow(constant sClInConstants *consts, sRenderData *renderData,
	sShaderInputDataCl *input, __global sLightCl *light, float distance, float3 lightVector,
	sClCalcParams *calcParam, float intensity)
{
	float3 lightShaded = 1.0;
	float totalOpacity = 0.0f;
	float shadowTemp = 1.0f;

	bool cloudMode = consts->params.cloudsEnable;

	float DEFactor = consts->params.DEFactor;
	if (consts->params.iterFogEnabled || consts->params.distanceFogShadows || light->volumetric)
		DEFactor = 1.0f;
#ifdef CLOUDS
	DEFactor = consts->params.DEFactor * consts->params.volumetricLightDEFactor;
#endif

	float start = input->distThresh;

#ifdef MC_SOFT_SHADOWS
	float softRange;
	if (light->type == lightDirectional)
	{
		softRange = tan(light->softShadowCone);
	}
	else
	{
		float lightSize = sqrt(intensity) * light->size;
		softRange = lightSize / distance;
	}
#else
	float softRange = tan(light->softShadowCone);
#endif

	bool goThrough = input->material->subsurfaceScattering;

#if defined(USE_SUBSURFACE_SCATTERING) && defined(USE_INNER_COLORING)
	sShaderInputDataCl input2 = *input;
#endif

	float maxSoft = 0.0f;

	const bool bSoft = !goThrough && !cloudMode && !consts->params.iterFogEnabled
										 && !consts->params.distanceFogShadows && !consts->params.common.iterThreshMode
										 && !consts->params.interiorMode && softRange > 0.0f
										 && !(consts->params.monteCarloSoftShadows && consts->params.DOFMonteCarlo);

#ifdef MC_SOFT_SHADOWS
	float3 randomVector;
	randomVector.x = Random(10000, &input->randomSeed) / 5000.0f - 1.0f;
	randomVector.y = Random(10000, &input->randomSeed) / 5000.0f - 1.0f;
	randomVector.z = Random(10000, &input->randomSeed) / 5000.0f - 1.0f;
	float randomSphereRadius = pow(Random(10000, &input->randomSeed) / 10000.0f, 1.0f / 3.0f);
	float3 randomSphere = randomVector * (softRange * randomSphereRadius / length(randomVector));
	lightVector += randomSphere;
#endif // MC_SOFT_SHADOWS

	float lastDistanceToClouds = 1e6f;
	int count = 0;
	float step = 0.0f;

	for (float i = start; i < distance; i += step)
	{
		float3 point2 = input->point + lightVector * i;

		float dist_thresh;
		if (consts->params.iterFogEnabled || consts->params.distanceFogShadows || light->volumetric
				|| cloudMode || goThrough)
		{
			dist_thresh = CalcDistThresh(point2, consts);
		}
		else
			dist_thresh = input->distThresh;

		calcParam->distThresh = dist_thresh;
		formulaOut outF;

		outF = CalculateDistance(consts, point2, calcParam, renderData);
		float dist = outF.distance;

#ifdef USE_SUBSURFACE_SCATTERING
#ifdef FULL_ENGINE
		__global sObjectDataCl *objectData = &renderData->objectsData[outF.objectId];
		__global sMaterialCl *material = renderData->materials[objectData->materialId];
		goThrough = material->subsurfaceScattering;
#endif
#endif

		bool limitsAcheved = false;
#ifdef LIMITS_ENABLED
		limitsAcheved = any(isless(point2, consts->params.limitMin))
										|| any(isgreater(point2, consts->params.limitMax));
#endif // LIMITS_ENABLED

		if (bSoft && !limitsAcheved)
		{
			float angle = (dist - dist_thresh) / i;
			if (angle < 0.0f) angle = 0.0f;
			if (dist < dist_thresh) angle = 0.0f;
			float softShadow = 1.0f - angle / softRange;
			if (light->penetrating) softShadow *= (distance - i) / distance;
			if (softShadow < 0.0f) softShadow = 0.0f;
			if (softShadow > maxSoft) maxSoft = softShadow;
		}

#ifdef ITER_FOG
		{
			float opacity =
				IterOpacity(step, outF.iters, consts->params.N, consts->params.iterFogOpacityTrim,
					consts->params.iterFogOpacityTrimHigh, consts->params.iterFogOpacity);

			opacity *= (distance - i) / distance;
			opacity = min(opacity, 1.0f);
			totalOpacity = opacity + (1.0f - opacity) * totalOpacity;
		}
#endif

#if (defined(VOLUMETRIC_FOG) || defined(DIST_FOG_SHADOWS))
		if (consts->params.distanceFogShadows)
		{
			float distanceShifted;
			float opacity = DistanceFogOpacity(step, dist, consts->params.volFogDistanceFromSurface,
				consts->params.volFogDistanceFactor, consts->params.volFogDensity, &distanceShifted);
			opacity *= (distance - i) / distance;
			opacity = min(opacity, 1.0f);
			totalOpacity = opacity + (1.0f - opacity) * totalOpacity;
		}
#endif

#ifdef CLOUDS
		{
			float distanceToClouds = 0.0f;
			float opacity = CloudOpacity(consts, renderData->perlinNoiseSeeds, point2, dist, dist_thresh,
												&distanceToClouds)
											* step;
			lastDistanceToClouds = distanceToClouds;
			opacity *= (distance - i) / distance;
			opacity = min(opacity, 1.0f);
			totalOpacity = opacity + (1.0f - opacity) * totalOpacity;
		}
#endif

#if defined(USE_SUBSURFACE_SCATTERING) && defined(FULL_ENGINE)
		if (goThrough && dist < dist_thresh)
		{

			float opacityGradient = 1.0f;
#if defined(USE_INNER_COLORING) && defined(USE_DIFFUSE_GRADIENT)
			if (material->insideColoringEnable && material->diffuseGradientEnable)
			{
				sClGradientsCollection gradients;
				input2.objectId = outF.objectId;
				input2.point = point2;
				SurfaceColor(consts, renderData, &input2, calcParam, &gradients);
				opacityGradient = gradients.diffuse.s0;
			}
#endif

			float opacity = (-1.0f + 1.0f / (material->transparencyOfInterior * opacityGradient)) * step;
			opacity *= (distance - i) / distance;
			opacity = min(opacity, 1.0f);
			totalOpacity = opacity + (1.0f - opacity) * totalOpacity;
			dist = CalcDelta(point2, consts);
		}
#endif

		shadowTemp = 1.0f - totalOpacity;

		if ((!goThrough && (dist < dist_thresh || shadowTemp < 0.0f))
				|| (goThrough && shadowTemp < 0.0001f))
		{
			if (light->penetrating)
			{
				shadowTemp -= (distance - i) / distance;
				if (shadowTemp < 0.0f) shadowTemp = 0.0f;
			}
			else
			{
				shadowTemp = 0.0f;
			}
			break;
		}
		step = min(dist, lastDistanceToClouds) * DEFactor;
		step = max(step, 1e-6f);

		count++;
		if (count > MAX_RAYMARCHING) break;
	}

	if (!bSoft)
	{
		lightShaded = shadowTemp;
	}
	else
	{
		lightShaded = 1.0f - maxSoft;
	}

	return lightShaded;
}
#endif // SHADOWS
#endif // AUX_LIGHTS
