Shader "Custom/Unlit/OutlineShader"
{
	Properties{
		//インスペクタからテクスチャを設定できるようにする
		_MainTex("Texture", 2D) = "white"{}
		_Color ("Main Color", Color) = (.5,.5,.5,1)
		_OutlineColor ("Outline Color", Color) = (0,0,0,1)
		_Outline ("Outline width", Range(.002, 0.03)) = .005
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100


		Pass
		{


			CGPROGRAM
			//Vertex shader,Fragment shader宣言
			#pragma vertex vert
			#pragma fragment frag

			//便利マクロをインクルード
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

			//unityから送られてくる頂点の情報
			//型 変数名 : セマンティクス
			struct appdata
			{
				float4 vertex : POSITION; //頂点座標
				fixed3 color : COLOR0; //頂点カラー
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				fixed3 color : COLOR0;
				float2 uv : TEXCOORD0;
			};

			uniform float _Outline;
			uniform float4 _OutlineColor;

			//メッシュの頂点座標を加工
			v2f vert (appdata v)
			{
				v2f o;
				//三角形メッシュ頂点の座標変換
				//mulは乗算
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
//				float3 norm = mul((float3x3)UNITY_MATRIX_IT_MV,v.normal);
//				float2 offset = TransformViewToProjection(norm.xy);
//				o.vertex.xy += offset * o.vertex.z * _Outline;
//				o.color = _OutlineColor;

				//あとで書き換え
//				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				//テクスチャ用のuv座標を作成
				o.uv.x = v.uv.x * _MainTex_ST.x + _MainTex_ST.z;
				o.uv.y = v.uv.y * _MainTex_ST.y + _MainTex_ST.w;

				o.color = v.color;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				//テクスチャのピクセルカラーを取得
				fixed4 texCol = tex2D(_MainTex, i.uv);
				//線形補間された色
				//頂点カラーとテクスチャのカラーを合成
				fixed4 o = fixed4(i.color, 1) * texCol;
				return o;
			}
			ENDCG
		}

		Pass
		{
			Cull Front
			ZWrite On
			ColorMask RGB
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			//Vertex shader,Fragment shader宣言
			#pragma vertex vert
			#pragma fragment frag

			//便利マクロをインクルード
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

			//unityから送られてくる頂点の情報
			//型 変数名 : セマンティクス
			struct appdata
			{
				float4 vertex : POSITION; //頂点座標
				fixed3 color : COLOR0; //頂点カラー
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				fixed3 color : COLOR0;
				float2 uv : TEXCOORD0;
			};

			uniform float _Outline;
			uniform float4 _OutlineColor;

			//メッシュの頂点座標を加工
			v2f vert (appdata v)
			{
				v2f o;
				//三角形メッシュ頂点の座標変換
				//mulは乗算
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				float3 norm = mul((float3x3)UNITY_MATRIX_IT_MV,v.normal);
				float2 offset = TransformViewToProjection(norm.xy);
				o.vertex.xy += offset * o.vertex.z * _Outline;
				o.color = _OutlineColor;

				//あとで書き換え
//				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				//テクスチャ用のuv座標を作成
				o.uv.x = v.uv.x * _MainTex_ST.x + _MainTex_ST.z;
				o.uv.y = v.uv.y * _MainTex_ST.y + _MainTex_ST.w;

//				o.color = v.color;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				//テクスチャのピクセルカラーを取得
				fixed4 texCol = tex2D(_MainTex, i.uv);
				//線形補間された色
				//頂点カラーとテクスチャのカラーを合成
				fixed4 o = fixed4(i.color, 1) * texCol;
				return o;
			}
			ENDCG
		}
	}
}