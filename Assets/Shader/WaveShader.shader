Shader "Custom/Unlit/WaveShader"
{
	Properties{
		_MainTex("MainTexture", 2D) = "white"{}
		_SubTex("SubTexture", 2D) = "white"{}
	}

	SubShader
	{
		Tags { 
			"RenderType" = "Transparent" 
			"Queue" = "Transparent"
		}
		Blend SrcAlpha OneMinusSrcAlpha
		LOD 100

		Pass
		{
			CGPROGRAM
			//Vertex shader,Fragment shader宣言
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _SubTex;
			float _Blend1;

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

			struct Input{
				float2 uv_MainTex;
			};

			//メッシュの頂点座標を加工
			v2f vert (appdata v)
			{
				v2f o;
		
				o.vertex = mul(_Object2World, v.vertex);

				float phase = _Time * 50.0;
				float offset = (o.vertex.z * 0.1);

				o.vertex.y = sin(phase + offset) * 2.0;
				o.vertex = mul(_World2Object, o.vertex);
				o.vertex = mul(UNITY_MATRIX_MVP, o.vertex);

				o.uv.x = v.uv.x + _Time;
				o.uv.y = v.uv.y + _Time / 2;

				o.color = v.color;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 mainTexCol = tex2D(_MainTex, i.uv);
				fixed4 subTexCol = tex2D(_SubTex, i.uv);
				fixed4 mixTexCol = mainTexCol * subTexCol;
				fixed4 col = fixed4(i.color, 1.0) * mixTexCol;
				return col;
			}
			ENDCG
		}
	}
}