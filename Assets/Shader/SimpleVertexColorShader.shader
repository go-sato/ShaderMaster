Shader "Custom/Unlit/SimpleVertexColorShader"
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
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				fixed3 color : COLOR0;
			};

			//メッシュの頂点座標を加工
			v2f vert (appdata v)
			{
				v2f o;
				//三角形メッシュ頂点の座標変換
				//UNITY_MATRIX_MVP 現在のモデルビュー行列 * 射影行列
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.color = v.color;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return fixed4(i.color, 1);
			}
			ENDCG
		}
	}
}