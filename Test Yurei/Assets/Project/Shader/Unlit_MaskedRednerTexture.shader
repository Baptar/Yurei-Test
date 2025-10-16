Shader "Unlit/MaskedRenderTexture"
{
    Properties
    {
        _MainTex ("RenderTexture", 2D) = "white" {}
        _Mask ("Mask Texture", 2D) = "white" {}
        _BorderColor ("Border Color", Color) = (0,0,0,1)
        _BorderThickness ("Border Thickness", Range(0,0.02)) = 0.005
        _UseBorder ("Enable Border", Float) = 1
    }

    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 100

        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _Mask;
            float4 _MainTex_ST;
            float4 _BorderColor;
            float _BorderThickness;
            float _UseBorder;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float mask = tex2D(_Mask, i.uv).r;

                // Bordure "manga" — détection des bords du masque
                if (_UseBorder > 0.5)
                {
                    float2 offset = float2(_BorderThickness, 0);
                    float maskX = tex2D(_Mask, i.uv + offset).r;
                    float maskY = tex2D(_Mask, i.uv + offset.yx).r;
                    float border = step(mask, 0.99) * (maskX < 0.9 || maskY < 0.9);
                    if (border > 0.5)
                        return _BorderColor;
                }

                // Appliquer le masque (alpha)
                col.a *= mask;
                return col;
            }
            ENDCG
        }
    }

    FallBack "Unlit/Transparent"
}
