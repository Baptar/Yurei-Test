Shader "Custom/MaskedRenderTexturePixelPerfectFixed"
{
    Properties
    {
        _MainTex ("Render Texture", 2D) = "white" {}
        _MaskTex ("Mask Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainTex_TexelSize; // x=1/w, y=1/h, z=w, w=h

            sampler2D _MaskTex;
            float4 _MaskTex_ST;
            float4 _MaskTex_TexelSize;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // Calcul du demi-pixel pour centrer correctement
                float2 uvMain = TRANSFORM_TEX(i.uv, _MainTex) + float2(_MainTex_TexelSize.x, _MainTex_TexelSize.y) * 0.5;
                float2 uvMask = TRANSFORM_TEX(i.uv, _MaskTex) + float2(_MaskTex_TexelSize.x, _MaskTex_TexelSize.y) * 0.5;

                // Sample RenderTexture et Mask
                fixed4 col = tex2D(_MainTex, uvMain);
                fixed4 mask = tex2D(_MaskTex, uvMask);

                // Applique le masque
                col.a *= mask.r;

                return col;
            }
            ENDCG
        }
    }
}
