Shader "Custom/Unlit/VertexColorShader"
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

//			#include "UnityCG.cginc"


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
				o.color = v.color;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				//線形補間された色
				return fixed4(i.color, 1);
			}
			ENDCG
		}
	}
}