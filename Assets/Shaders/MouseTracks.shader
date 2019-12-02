Shader "Custom/MouseTracks"
{
    Properties
    {
	    _MainTex ("Main (RGB)", 2D) = "white" {}
		_MainTex2 ("Main2 (RGB)", 2D) = "white" {}
        _MainColor ("Main Color", Color) = (1,1,1,1)
		_Main2Color ("Main Color 2", Color) = (1,1,1,1)
		_Splat ("Splat Map", 2D) = "black" {}
        [HideInInspector] _Glossiness ("Smoothness", Range(0,1)) = 0.0
        [HideInInspector] _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:disp

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 4.6

            struct appdata {
                float4 vertex : POSITION;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
            };

            sampler2D _Splat;

            void disp (inout appdata v)
            {
                v.vertex.xyz -= v.normal;
				v.vertex.xyz += v.normal;
            }

		sampler2D _MainTex;
		sampler2D _MainTex2;
		fixed4 _Main2Color;
		fixed4 _MainColor;

        struct Input
        {
			float2 uv_MainTex;
			float2 uv_MainTex2;
            float2 uv_Splat;
        };

        half _Glossiness;
        half _Metallic;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
		half amount = tex2Dlod(_Splat, float4(IN.uv_Splat,0,0)).r;
			// layers snow texture above ground and and replaces it
			fixed4 c = lerp(tex2D (_MainTex, IN.uv_MainTex) * _MainColor, tex2D (_MainTex2, IN.uv_MainTex2) * _Main2Color, amount );
            // Albedo is texture tinted by colour
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
