// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "STShader/Refraction"
{
	Properties
	{
		[HDR]_MainColor ("Main Color", Color) = (0,0,0,1)
		_Fresnel ("Fresnel", Range(0, 1)) = 0.5
		_FresnelColor ("Fresnel Color", Color) = (1,1,1,1)
		_Shininess ("Specular Shininess", Range(0, 1)) = 0.0
		_Refraction ("Refraction", Range(0, 1)) = 0.5 //屈折
		_Reflection ("Reflection", Range(0, 1)) = 0.5 //反射
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_Cube("Reflection Map", Cube) = "" {}
		
	}
	
	SubShader
	{
		Tags { "Queue" = "Transparent" }
		GrabPass {"_RefractTarget"}

		Tags { "Queue"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			uniform float4 _LightColor0;
			uniform float _Shininess;
			uniform float _Fresnel;
			uniform float4 _FresnelColor;
			uniform float _Refraction;
			uniform float _Reflection;
			uniform float4 _MainColor;
			uniform samplerCUBE _Cube;

			uniform sampler2D _RefractTarget ;
			
			struct v_input
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT; //接戦
			};

			struct v_output
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 uvgrab : TEXCOORD1;
				float3 normalDir :TEXCOORD2;
				float3 viewDir : TEXCOORD3;
				float3 lightDir : TEXCOORD4;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;

			float fresnel(float3 V, float3 N, float P)
			{	
				//saturate:0~1の範囲にクランプする
				//dot:2つのベクトルの内積を返す
				//内積が大きければ大きいほど輝度が小さくなる
				//指数大きければ大きいほどフレネル反射の端が外側に寄る
				//ピクセル一つずつやってるの？？
				return pow(1 - saturate(dot(V,N)), P);
			}
			
			v_output vert (v_input v)
			{
				v_output o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
				#else
				float scale = 1.0;
				#endif
				o.uvgrab.xy = ( float2( o.vertex.x, (o.vertex.y * scale)) + o.vertex.w) * 0.5; 
                o.uvgrab.zw = o.vertex.zw;  
				o.viewDir = normalize(mul(unity_ObjectToWorld, v.vertex).xyz - _WorldSpaceCameraPos);
				o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				o.lightDir = normalize(_WorldSpaceLightPos0.xyz);
				return o;
			}
			
			float4 frag (v_output i) : SV_Target
			{
			//Bump offset
				float2 bump = UnpackNormal(tex2D (_BumpMap, i.uv)).rg;
				float2 offset = bump * _Refraction * 0.1;
				
			//MainColor
				float3 mainCol = tex2D (_MainTex, i.uv + offset) * _MainColor;

			//CubeMap Refraction
			//	float3 refractDir = refract(i.viewDir, normal, min(1.0 - _Refraction, 1.0) );
			//	float3 refractCol = DecodeHDR(texCUBE(_Cube, refractDir), float4(1,1,0,0)) * unity_ColorSpaceDouble.rgb;

			//RealTime Refraction
				i.uvgrab.xy = offset * i.uvgrab.z + i.uvgrab.xy;
				float3 refractCol = tex2Dproj ( _RefractTarget , (UNITY_PROJ_COORD(i.uvgrab)));
				
			//CubeMap Reflection
				float3 reflectDir = reflect(i.viewDir, i.normalDir);
				float3 reflectCol = DecodeHDR(texCUBE(_Cube, reflectDir), float4(1,1,0,0)) * unity_ColorSpaceDouble.rgb;

			//Composite Refraction and Reflection
				float3 refFactor = fresnel(i.normalDir, -i.viewDir, 1.0 /_Reflection);
				float3 lerped = lerp(refractCol, reflectCol, saturate(refFactor));

			//Specular
				float specFactor = pow(max(dot(reflect(i.lightDir, i.normalDir), i.viewDir), 0.01), _Shininess * 100);
				float3 specCol = lerped * specFactor * _FresnelColor * (1.0 - _FresnelColor.a);

			//Fresnel
				float freFactor = fresnel(i.normalDir, -i.viewDir, _Fresnel * 10);
				float3 freCol = lerped * freFactor * _FresnelColor * _FresnelColor.a;

				return float4(mainCol + (lerped + specCol + freCol) , 1);
			}
			ENDCG
		}

	}
}
