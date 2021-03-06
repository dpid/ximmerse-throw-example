﻿Shader "Ximmerse/ToyBox-Hand" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_BumpMap ("Bumpmap", 2D) = "bump" {}
		_RimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)
		_RimPower ("Rim Power", Float) = 3.0
		_kNrmAlpha ("kNrmAlpha", Float) = 1.0
	}

	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		Pass {
			ZWrite On
			ColorMask 0
		}

		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows alpha:blend

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0
		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 viewDir;
		};

		sampler2D _MainTex;
		
		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		sampler2D _BumpMap;
		half4 _RimColor;
		float _RimPower,_kNrmAlpha;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;

			// Rim
			o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
			half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
			o.Emission=_RimColor.rgb * pow (rim, _RimPower);
			// TODO
			rim=1.0f-_kNrmAlpha*dot(o.Normal,IN.viewDir);
			if(rim>0){
				o.Alpha=_Color.a*rim;
			}else{
				o.Alpha=0.0f;
			}
		}
		ENDCG
		//}
	}

	Fallback "Legacy Shaders/Transparent/VertexLit"
}
