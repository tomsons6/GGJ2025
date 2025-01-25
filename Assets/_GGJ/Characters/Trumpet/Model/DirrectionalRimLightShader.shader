Shader "Custom/DirectionalRimLightShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Color("Main Color", Color) = (1,1,1,1)
        _RimColor("Rim Color", Color) = (1,1,1,1)
        _RimPower("Rim Power", Range(0.5, 8.0)) = 3.0
        _LightDir("Light Direction", Vector) = (0,1,0)
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

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
