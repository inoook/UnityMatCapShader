/**
 * @author dizgid Kenji Inokuchi / http://www.dizgid.com/
 *
 * MatCapSimple Shader
 * Ported from MatCap with WebGL
 * http://mua.github.io/matcap-webgl.html
 * https://github.com/mua/mua.github.io/tree/master/models/matcap
 *
 */

Shader "Custom/MatCapSimple" {
	Properties
	{
		_MatCap ("MatCap (RGB)", 2D) = "white" {}
	}
	
	Subshader
	{
		Tags { "RenderType"="Opaque" }
		
		Pass
		{
			Tags { "LightMode" = "Always" }
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members vNormal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#include "UnityCG.cginc"
				
				struct v2f
				{
					float4 pos	: SV_POSITION;
					float3 vNormal : TEXCOORD0;
				};
				
				v2f vert (appdata_base v)
				{
					v2f o;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.vNormal = normalize( v.normal ); // Normal in model space
					
					return o;
				}
				
				uniform sampler2D _MatCap;
				
				float4 frag (v2f i) : COLOR
				{
					float3 vNormal = normalize(i.vNormal);
					float4 m4 = mul(UNITY_MATRIX_V, float4( vNormal.x, vNormal.y, vNormal.z, 0) );
					float2 muv = float2(m4.x, m4.y) * 0.5 +float2(0.5, 0.5);
					float4 mc = tex2D(_MatCap, float2(muv.x, 1.0 - muv.y));
					
					return mc;
				}
			ENDCG
		}
	}
}
