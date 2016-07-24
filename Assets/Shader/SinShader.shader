Shader "Custom/Unlit/SinShader"
{
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

			#include "UnityCG.cginc"


			//unityから送られてくる頂点の情報
			//型 変数名 : セマンティクス
			struct appdata
			{
				float4 vertex : POSITION; //頂点座標
				fixed3 color : COLOR0; //頂点カラー
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				fixed3 color : COLOR0;
				float2 uv : TEXCOORD0;
			};

			//メッシュの頂点座標を加工
			v2f vert (appdata v)
			{
				v2f o;
				//三角形メッシュ頂点の座標変換
				//mulは乗算
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				//あとで書き換え
//				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				//テクスチャ用のuv座標を作成
				o.uv.x = v.uv.x*2;
				o.uv.y = v.uv.y;

				o.color = v.color;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed3 col = (0,0,0);
				//sin波の模様
				col.y = abs(0.1 / (sin(2.0 * 3.14 * i.uv.x + _Time * 100) * 0.5 + 0.5 - i.uv.y));
				return fixed4(col,1.0f);
			}
			ENDCG
		}
	}
}