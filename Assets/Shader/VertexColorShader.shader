Shader "Custom/Unlit/VertexColorShader"
{
	Properties{
		//インスペクタからテクスチャを設定できるようにする
		_MainTex("Texture", 2D) = "white"{}
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
//			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

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

			uniform float4x4 mvp_matrix;
			uniform float4x4 mv_matrix;
			uniform float4x4 v_matrix;

			//メッシュの頂点座標を加工
			v2f vert (appdata v)
			{
				v2f o;
				//三角形メッシュ頂点の座標変換
				//mulは乗算
				o.vertex = mul(mvp_matrix, v.vertex);

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
	}
}