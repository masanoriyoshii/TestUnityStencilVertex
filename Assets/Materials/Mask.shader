Shader "Test/Mask" 
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
		_Max ("Max", Range(0.1, 100)) = 5
    }
    SubShader
    {
        Tags 
		{ 
			"RenderType"="Transparent" 
			"Queue"="Transparent" 
		}

        Pass
        {
            Stencil
			{
                Ref 1
                Comp always
                Pass replace
            }

            Tags { "LightMode"="ForwardBase" }

            ZWrite On
			ZTest LEqual
			Blend SrcAlpha OneMinusSrcAlpha 

            CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"

            struct v2f
            {
                fixed4 diff : COLOR0;
                float4 vertex : SV_POSITION;            
			};

            half4 _Color;
			float _Max;
            
            v2f vert (appdata_base v)
            {
                v2f o;
				//float4 p = v.vertex;
				float4 p = mul (unity_ObjectToWorld, v.vertex);
				p.y = min(abs(p.y), _Max) * sign(p.y);
				p = mul(unity_WorldToObject, p);
                o.vertex = UnityObjectToClipPos(p);
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = nl * _LightColor0;
                return o;  
			}
            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = _Color;
                col.rgb *= i.diff;
                return col;
            }
            ENDCG
        }
    }
}