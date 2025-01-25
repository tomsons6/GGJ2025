Shader "Custom/RimLightWithOutlineShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Color("Main Color", Color) = (1,1,1,1)
        _RimColor("Rim Color", Color) = (1,1,1,1)
        _RimPower("Rim Power", Range(0.5, 8.0)) = 3.0
        _LightDir("Light Direction", Vector) = (0,1,0)
        _OutlineColor("Outline Color", Color) = (0,0,0,1)
        _OutlineThickness("Outline Thickness", Range(0.001, 0.1)) = 0.01
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            Pass
            {
                Name "OUTLINE"
                Tags { "LightMode" = "Always" }

                Cull Front

                ZWrite On
                ZTest LEqual

                ColorMask RGB
                Blend SrcAlpha OneMinusSrcAlpha

                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc"

                uniform float _OutlineThickness;
                uniform float4 _OutlineColor;

                struct appdata
                {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                };

                struct v2f
                {
                    float4 pos : POSITION;
                    float4 color : COLOR;
                };

                v2f vert(appdata v)
                {
                    // Vertex shader for outline
                    v2f o;
                    float3 norm = mul((float3x3) unity_ObjectToWorld, v.normal);
                    o.pos = UnityObjectToClipPos(v.vertex + norm * _OutlineThickness);
                    o.color = _OutlineColor;
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    // Fragment shader for outline
                    return i.color;
                }
                ENDCG
            }

            CGPROGRAM
            #pragma surface surf Lambert

            sampler2D _MainTex;
            fixed4 _Color;
            fixed4 _RimColor;
            float _RimPower;
            float3 _LightDir;

            struct Input
            {
                float2 uv_MainTex;
                float3 viewDir;
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
                o.Albedo = c.rgb;
                o.Alpha = c.a;

                float rim = 1.0 - saturate(dot(normalize(_LightDir), o.Normal));
                o.Emission = _RimColor.rgb * pow(rim, _RimPower);
            }
            ENDCG
        }
            FallBack "Diffuse"
}
