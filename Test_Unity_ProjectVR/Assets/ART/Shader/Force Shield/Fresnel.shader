// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Fresnel"
{
	Properties
	{
		_ShieldRim("ShieldRim", Range( 0 , 10)) = 0
		_hitsize("hitsize", Float) = 0.5
		_Animationspeed("Animation speed", Range( 0 , 10)) = 2.312685
		_animationScale("animationScale", Range( 0 , 0.1)) = 0.1
		_Color2("Color 2", Color) = (0,0.9086068,1,0)
		_HitPosition("Hit Position", Vector) = (0,0,0,0)
		_HitTime("Hit Time", Float) = 0
		_IntersectColor("Intersect Color", Color) = (0.03137255,0.2588235,0.3176471,1)
		_Color1("Color 1", Color) = (0.03137255,0.2588235,0.3176471,1)
		_ShieldPatternWaves("Shield Pattern Waves", 2D) = "white" {}
		_Float2("Float 2", Range( -10 , 10)) = 3
		_HitColor("Hit Color", Color) = (0.3632075,0.95925,1,1)
		_HitSize("Hit Size", Float) = 0.2
		_IntersectIntensity("Intersect Intensity", Range( 0 , 1)) = 0.2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float _Animationspeed;
		uniform float _animationScale;
		uniform float _hitsize;
		uniform float4 _Color2;
		uniform float _ShieldRim;
		uniform float4 _IntersectColor;
		uniform float4 _Color1;
		uniform float3 _HitPosition;
		uniform float _HitSize;
		uniform float4 _HitColor;
		uniform float _HitTime;
		uniform sampler2D _ShieldPatternWaves;
		uniform float _Float2;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _IntersectIntensity;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float simplePerlin2D29 = snoise( ( ase_vertexNormal + ( _Time.x * _Animationspeed ) ).xy );
			float3 temp_cast_1 = ((( _animationScale * 0.0 ) + (simplePerlin2D29 - 0.0) * (_animationScale - ( _animationScale * 0.0 )) / (1.0 - 0.0))).xxx;
			v.vertex.xyz += temp_cast_1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 color4 = IsGammaSpace() ? float4(0,1,1,0) : float4(0,1,1,0);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV1 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode1 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV1, (10.0 + (_ShieldRim - 0.0) * (0.0 - 10.0) / (10.0 - 0.0)) ) );
			o.Albedo = (( distance( ase_vertex3Pos , float3( 0,0,0 ) ) < _hitsize ) ? _Color2 :  ( color4 * fresnelNode1 ) ).rgb;
			float4 colorpatern89 = _Color1;
			float temp_output_41_0 = distance( ase_vertex3Pos , _HitPosition );
			float HitSize95 = _HitSize;
			float4 HitColor92 = _HitColor;
			float4 lerpResult52 = lerp( colorpatern89 , ( HitColor92 * ( HitSize95 / temp_output_41_0 ) ) , (0.0 + (_HitTime - 0.0) * (1.0 - 0.0) / (100.0 - 0.0)));
			float4 hit55 = (( 0.0 > 0.0 ) ? (( temp_output_41_0 < HitSize95 ) ? lerpResult52 :  colorpatern89 ) :  colorpatern89 );
			float fresn69 = fresnelNode1;
			float2 appendResult76 = (float2(1 , ( 1.0 - ( ( _Time * _Float2 ) / 5.0 ) ).x));
			float2 uv_TexCoord77 = i.uv_texcoord * float2( 1,0.5 ) + appendResult76;
			float4 waves79 = tex2D( _ShieldPatternWaves, uv_TexCoord77 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth98 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float distanceDepth98 = abs( ( screenDepth98 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _IntersectIntensity ) );
			float clampResult99 = clamp( distanceDepth98 , 0.0 , 1.0 );
			float4 lerpResult58 = lerp( _IntersectColor , ( ( colorpatern89 * hit55 ) * ( fresn69 * waves79 ) ) , clampResult99);
			float4 Emission60 = ( lerpResult58 * float4( 0,0,0,0 ) );
			o.Emission = Emission60.rgb;
			o.Alpha = ( fresnelNode1 * 0.5 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
1997;30;1918;1017;1858.349;197.4556;1.663719;True;True
Node;AmplifyShaderEditor.PosVertexDataNode;40;-1078.79,1085.571;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;39;-1070.183,1269.87;Float;False;Property;_HitPosition;Hit Position;5;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;96;-1633.361,1068.686;Float;False;Property;_HitSize;Hit Size;12;0;Create;True;0;0;False;0;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;-1420.161,1072.586;Float;False;HitSize;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;91;-1207.823,769.8383;Float;False;Property;_HitColor;Hit Color;11;0;Create;True;0;0;False;0;0.3632075,0.95925,1,1;0.04313726,0.95925,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;84;-1688.693,2635.229;Float;False;Property;_Float2;Float 2;10;0;Create;True;0;0;False;0;3;-2.207526;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;83;-1615.101,2442.074;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;41;-838.5855,1169.171;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-618.5975,1338.438;Float;False;95;HitSize;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;42;-661.6883,1408.938;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;88;-1348.453,1686.188;Float;False;Property;_Color1;Color 1;8;0;Create;True;0;0;False;0;0.03137255,0.2588235,0.3176471,1;0.9568627,1,0.9381459,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-926.6522,772.3911;Float;False;HitColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-1372.565,2565.488;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-1267.063,2870.653;Float;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;82;-1086.095,2797.911;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;45;-423.8942,1542.839;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-406.8002,1453.539;Float;False;92;HitColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;89;-1046.942,1696.706;Float;False;colorpatern;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-603.5013,1199.685;Float;False;Property;_HitTime;Hit Time;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;73;-902.3148,2704.375;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;74;-895.3868,2546.769;Float;False;Constant;_Vector2;Vector 2;7;0;Create;True;0;0;False;0;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-180.7003,1460.239;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;49;-370.3984,1278.239;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;100;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-220.4972,1001.839;Float;False;89;colorpatern;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-729,-39.5;Float;False;Property;_ShieldRim;ShieldRim;0;0;Create;True;0;0;False;0;0;9.55;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;76;-699.6779,2598.727;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-239.3674,1127.932;Float;False;95;HitSize;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;75;-702.9867,2474.914;Float;False;Constant;_Vector3;Vector 3;7;0;Create;True;0;0;False;0;1,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;50;-309.6733,1067.777;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;52;-40.59834,1267.139;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCCompareLower;53;149.5157,1146.203;Float;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;77;-503.9676,2590.067;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;3;-450.22,-41.01997;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;10;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;78;-262.0677,2574.695;Float;True;Property;_ShieldPatternWaves;Shield Pattern Waves;9;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCCompareGreater;54;290.9036,898.4041;Float;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;1;-245,-22.5;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;13.69171,-54.87097;Float;False;fresn;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;90.54336,2630.552;Float;False;waves;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;487.2037,902.2114;Float;False;hit;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-821.4246,2087.051;Float;False;69;fresn;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-833.3567,1966.594;Float;False;55;hit;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;90;-847.1042,1870.249;Float;False;89;colorpatern;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-832.2568,2194.364;Float;False;79;waves;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-795.1346,2311.369;Float;False;Property;_IntersectIntensity;Intersect Intensity;13;0;Create;True;0;0;False;0;0.2;0.5536237;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;98;-463.9938,2314.262;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-619.2187,1952.639;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-622.4069,2140.123;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-377.709,2047.203;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.1686275,0.5411765,0.2235294,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TimeNode;23;-999.4316,385.7182;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;99;-212.8409,2276.69;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;67;-357.9443,1770.113;Float;False;Property;_IntersectColor;Intersect Color;7;0;Create;True;0;0;False;0;0.03137255,0.2588235,0.3176471,1;1,1,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-939.9517,577.8834;Float;False;Property;_Animationspeed;Animation speed;2;0;Create;True;0;0;False;0;2.312685;4.02;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;26;-793.5405,204.2289;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;58;-105.3852,2043.067;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-749.3115,396.3941;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;137.2127,2073.071;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;4;-403.6868,-263.019;Float;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;False;0;0,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-541.8948,323.1883;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-558.1194,594.7424;Float;False;Property;_animationScale;animationScale;3;0;Create;True;0;0;False;0;0.1;0.0206;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;32;-882.6749,-762.9943;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;37;-945.6464,-333.5563;Float;False;Property;_Color2;Color 2;4;0;Create;True;0;0;False;0;0,0.9086068,1,0;0,0.9086068,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-109.2496,200.7061;Float;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-835.675,-452.9952;Float;False;Property;_hitsize;hitsize;1;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;29;-386.3325,185.5434;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;320.5137,2048.068;Float;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-291.3158,434.2593;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;34;-631.6739,-699.9948;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-30.67517,-165.891;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;109.4904,31.24579;Float;False;60;Emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCCompareLower;38;-190.0734,-631.8941;Float;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;31;-41.09095,435.0262;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;77.1312,156.1831;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;286,-117;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Fresnel;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;95;0;96;0
WireConnection;41;0;40;0
WireConnection;41;1;39;0
WireConnection;42;0;41;0
WireConnection;92;0;91;0
WireConnection;85;0;83;0
WireConnection;85;1;84;0
WireConnection;82;0;85;0
WireConnection;82;1;81;0
WireConnection;45;0;43;0
WireConnection;45;1;42;0
WireConnection;89;0;88;0
WireConnection;73;0;82;0
WireConnection;48;0;44;0
WireConnection;48;1;45;0
WireConnection;49;0;46;0
WireConnection;76;0;74;1
WireConnection;76;1;73;0
WireConnection;50;0;41;0
WireConnection;52;0;47;0
WireConnection;52;1;48;0
WireConnection;52;2;49;0
WireConnection;53;0;50;0
WireConnection;53;1;51;0
WireConnection;53;2;52;0
WireConnection;53;3;47;0
WireConnection;77;0;75;0
WireConnection;77;1;76;0
WireConnection;3;0;2;0
WireConnection;78;1;77;0
WireConnection;54;2;53;0
WireConnection;54;3;47;0
WireConnection;1;3;3;0
WireConnection;69;0;1;0
WireConnection;79;0;78;0
WireConnection;55;0;54;0
WireConnection;98;0;97;0
WireConnection;87;0;90;0
WireConnection;87;1;62;0
WireConnection;70;0;71;0
WireConnection;70;1;80;0
WireConnection;64;0;87;0
WireConnection;64;1;70;0
WireConnection;99;0;98;0
WireConnection;58;0;67;0
WireConnection;58;1;64;0
WireConnection;58;2;99;0
WireConnection;25;0;23;1
WireConnection;25;1;24;0
WireConnection;59;0;58;0
WireConnection;27;0;26;0
WireConnection;27;1;25;0
WireConnection;29;0;27;0
WireConnection;60;0;59;0
WireConnection;30;0;28;0
WireConnection;34;0;32;0
WireConnection;5;0;4;0
WireConnection;5;1;1;0
WireConnection;38;0;34;0
WireConnection;38;1;35;0
WireConnection;38;2;37;0
WireConnection;38;3;5;0
WireConnection;31;0;29;0
WireConnection;31;3;30;0
WireConnection;31;4;28;0
WireConnection;6;0;1;0
WireConnection;6;1;7;0
WireConnection;0;0;38;0
WireConnection;0;2;65;0
WireConnection;0;9;6;0
WireConnection;0;11;31;0
ASEEND*/
//CHKSM=9A721427EB7ADE3493BE186F53133DDC03FBDA75