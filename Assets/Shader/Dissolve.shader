Shader "Custom/Surf/Dissolve"
{
	Properties
	{
		_MainColor("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (rgb)", 2D) = "white" {}
		_Mask("Mask TO Dissolve", 2D) = "White" {}
		_Cutoff("Cutoff Range", Range(0,1)) = 0
		_Width("Width", Range(0,1)) = 0.001
		_Color("Line Color", Color) = (1,1,1,1)
//		_BumpMap("Normalmap", 2D) = "bump" {}
	}

	SubShader
	{
		Tags { 
			"RenderType"="Transparent"
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
		}

		LOD 300


		CGPROGRAM
		#pragma target 2.0
		#include "UnityCG.cginc"
		#pragma surface surf Lambert alpha

		sampler2D _MainTex;
//			sampler2D _Bumpmap;
		sampler2D _Mask;
		fixed4 _Color;
		fixed4 _MainColor;
		fixed _Cutoff;
		fixed _Width;
		
		struct Input{
			float2 uv_MainTex;
			float2 uv_BumpMap;
		};
		
		void surf(Input IN, inout SurfaceOutput o){
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex) * _MainColor;
			fixed a = tex2D(_Mask, IN.uv_MainTex).r;
			fixed b = smoothstep(_Cutoff, _Cutoff + _Width, a);
			fixed b2 = step(a, _Cutoff + _Width * 2.0);
			o.Alpha = b2;
		}
		ENDCG
	}
	Fallback "Diffuse"
}
