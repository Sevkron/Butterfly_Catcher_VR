// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TreeLeaves"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 4
		_TreeOffset("Tree Offset", Vector) = (0,5,0,0)
		_MainTex("MainTex", 2D) = "white" {}
		_TreeInstanceColor("TreeInstanceColor", Color) = (0,0,0,0)
		_TreeInstanceScale("_TreeInstanceScale", Vector) = (0,0,0,0)
		_SecondaryFactor("SecondaryFactor", Float) = 0
		_PrimaryFactor("PrimaryFactor", Float) = 0
		_EdgeFlutter("EdgeFlutter", Float) = 1
		_NormalsTex("NormalsTex", 2D) = "bump" {}
		_BranchPhase("BranchPhase", Float) = 0
		_BaseCellSharpness("Base Cell Sharpness", Range( 0.01 , 1)) = 0.01
		_BaseCellOffset("Base Cell Offset", Range( -1 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TreeTransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#include "TerrainEngine.cginc"
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _BranchPhase;
		uniform float _EdgeFlutter;
		uniform float _PrimaryFactor;
		uniform float _SecondaryFactor;
		uniform float3 _TreeOffset;
		uniform sampler2D _NormalsTex;
		uniform float4 _NormalsTex_ST;
		uniform float _BaseCellOffset;
		uniform float _BaseCellSharpness;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _Cutoff = 0.5;
		uniform float _TessValue;


		float4 WindAnimateVertex1_g2( float4 Pos , float3 Normal , float4 AnimParams )
		{
			return AnimateVertex(Pos,Normal,AnimParams);
		}


		float4 tessFunction( )
		{
			return _TessValue;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float4 ase_vertex4Pos = v.vertex;
			float4 Pos1_g2 = ase_vertex4Pos;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 Normal1_g2 = ase_vertexNormal;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 normalizeResult52 = normalize( ase_worldPos );
			float4 appendResult15 = (float4(_BranchPhase , ( _EdgeFlutter * ( (normalizeResult52).x + (normalizeResult52).z ) ) , _PrimaryFactor , _SecondaryFactor));
			float4 AnimParams1_g2 = appendResult15;
			float4 localWindAnimateVertex1_g2 = WindAnimateVertex1_g2( Pos1_g2 , Normal1_g2 , AnimParams1_g2 );
			v.vertex.xyz = ( ( localWindAnimateVertex1_g2 * _TreeInstanceScale ) + float4( _TreeOffset , 0.0 ) ).xyz;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode3 = tex2D( _MainTex, uv_MainTex );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float2 uv_NormalsTex = i.uv_texcoord * _NormalsTex_ST.xy + _NormalsTex_ST.zw;
			float3 NewNormals106 = (WorldNormalVector( i , UnpackNormal( tex2D( _NormalsTex, uv_NormalsTex ) ) ));
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult64 = dot( NewNormals106 , ase_worldlightDir );
			float NdotL65 = dotResult64;
			float4 BaseColor91 = ( float4( ( ase_lightColor.rgb * saturate( ( ( NdotL65 + _BaseCellOffset ) / _BaseCellSharpness ) ) * ase_lightAtten ) , 0.0 ) * ( _TreeInstanceColor * tex2DNode3 ) );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult72 = dot( NewNormals106 , ase_worldViewDir );
			float3 LightColorFalloff95 = ( ase_lightColor.rgb * ase_lightAtten );
			c.rgb = ( BaseColor91 + float4( ( pow( ( 1.0 - saturate( ( dotResult72 + 60.0 ) ) ) , 0.001 ) * LightColorFalloff95 ) , 0.0 ) ).rgb;
			c.a = tex2DNode3.a;
			clip( tex2DNode3.a - _Cutoff );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float2 uv_NormalsTex = i.uv_texcoord * _NormalsTex_ST.xy + _NormalsTex_ST.zw;
			float3 NewNormals106 = (WorldNormalVector( i , UnpackNormal( tex2D( _NormalsTex, uv_NormalsTex ) ) ));
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult64 = dot( NewNormals106 , ase_worldlightDir );
			float NdotL65 = dotResult64;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode3 = tex2D( _MainTex, uv_MainTex );
			float4 BaseColor91 = ( float4( ( ase_lightColor.rgb * saturate( ( ( NdotL65 + _BaseCellOffset ) / _BaseCellSharpness ) ) * 1 ) , 0.0 ) * ( _TreeInstanceColor * tex2DNode3 ) );
			o.Albedo = BaseColor91.rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
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
Version=16105
-72;306.5;1547;791;6832.828;2111.131;7.011107;True;True
Node;AmplifyShaderEditor.CommentaryNode;104;-3039.948,-300.2549;Float;False;881.0978;260.4886;Comment;3;111;106;105;Normals;0.5220588,0.6044625,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;111;-2985.128,-241.0544;Float;True;Property;_NormalsTex;NormalsTex;13;0;Create;True;0;0;False;0;None;039ab720160e1e34983269870dc533c3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;105;-2653.719,-245.0145;Float;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;57;-2995.621,-797.7623;Float;False;835.6508;341.2334;Comment;4;65;64;62;107;N dot L;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-2431.404,-241.692;Float;False;NewNormals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-2939.719,-746.1036;Float;False;106;NewNormals;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;62;-2945.621,-635.5297;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;113;-1828.991,767.4213;Float;False;1942.196;644.2853;Terrain and Wind;16;22;23;28;6;31;15;18;56;19;16;17;48;53;54;52;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;64;-2621.329,-710.9639;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;47;-1769.023,979.7537;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;58;-2020.282,-357.7156;Float;False;1771.065;410.0065;Comment;13;91;86;81;75;79;76;74;69;70;67;66;3;29;Base Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;59;-2843.263,163.6085;Float;False;1379.584;401.6488;Comment;9;92;90;89;84;78;72;73;68;109;Rim Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-2402.97,-707.6482;Float;False;NdotL;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-1981.849,-154.3441;Float;False;65;NdotL;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-1973.475,-58.9846;Float;False;Property;_BaseCellOffset;Base Cell Offset;16;0;Create;True;0;0;False;0;0;-0.15;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;52;-1588.931,1010.761;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-2777.502,251.2136;Float;False;106;NewNormals;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;68;-2773.87,389.4104;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;73;-2498.529,427.7114;Float;False;Constant;_RimOffset;Rim Offset;19;0;Create;True;0;0;False;0;60;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;72;-2441.13,310.4945;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-1769.444,-149.7557;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-1697.095,-56.68885;Float;False;Property;_BaseCellSharpness;Base Cell Sharpness;15;0;Create;True;0;0;False;0;0.01;0.01;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;54;-1437.841,1066.147;Float;False;FLOAT;2;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;53;-1431.931,964.7607;Float;False;FLOAT;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;74;-1624.87,-151.0894;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;60;-1280.868,322.8748;Float;False;717.6841;295.7439;Comment;4;95;94;88;87;Light Falloff;0.9947262,1,0.6176471,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1095.185,949.8908;Float;False;Property;_EdgeFlutter;EdgeFlutter;12;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-1262.209,996.6277;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-2217.53,314.7114;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;79;-1381.109,-51.5372;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;87;-1230.868,508.6184;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;88;-1185.164,372.8747;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SaturateNode;75;-1477.17,-152.6395;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;76;-1324.997,-243.3302;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;3;-988.0051,-297.4414;Float;True;Property;_MainTex;MainTex;7;0;Create;True;0;0;False;0;None;47aa0725ec3f6de4e99a3ee8db0b3cc5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-1018.383,1149.958;Float;False;Property;_PrimaryFactor;PrimaryFactor;11;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1010.283,1253.858;Float;False;Property;_SecondaryFactor;SecondaryFactor;10;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-936.9519,1016.443;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;30;-950.7326,-586.4439;Float;False;Property;_TreeInstanceColor;TreeInstanceColor;8;0;Fetch;True;0;0;False;0;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;84;-2057.529,314.7114;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1028.983,840.6578;Float;False;Property;_BranchPhase;BranchPhase;14;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-764.6289,1026.085;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1993.529,442.7114;Float;False;Constant;_RimPower;Rim Power;18;0;Create;True;0;0;False;0;0.001;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;90;-1881.529,314.7114;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-1119.99,-131.4288;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-671.2963,-306.6396;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-996.8684,439.0357;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector4Node;31;-504.8742,1078.793;Float;False;Property;_TreeInstanceScale;_TreeInstanceScale;9;0;Fetch;True;0;0;False;0;0,0,0,0;1,1,1,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;92;-1689.529,314.7114;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-634.5977,-92.77632;Float;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;6;-568.5825,911.9576;Float;False;Terrain Wind Animate Vertex;-1;;2;3bc81bd4568a7094daabf2ccd6a7e125;0;3;2;FLOAT4;0,0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;-822.1844,435.5026;Float;False;LightColorFalloff;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;-481.2912,-97.5689;Float;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-242.7108,872.1047;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;23;-201.442,1140.844;Float;False;Property;_TreeOffset;Tree Offset;6;0;Create;True;0;0;False;0;0,5,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-378.4677,105.0791;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;27;-2377.733,1177.022;Float;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;24;-2054.732,1008.022;Float;False;TerrainBillboardTree(Pos, Offset, OffsetZ)@$return@;7;False;3;True;Pos;FLOAT4;0,0,0,0;InOut;;Float;True;Offset;FLOAT2;0,0;In;;Float;True;OffsetZ;FLOAT;0;In;;Float;TerrainBillboardTree;True;False;0;4;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT4;2
Node;AmplifyShaderEditor.TexCoordVertexDataNode;26;-2382.733,1019.022;Float;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-133.6205,-35.84554;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-65.79713,847.5599;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-5.016329,-306.0559;Float;False;91;BaseColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;25;-2353.733,842.0219;Float;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;7;296.9381,-306.5974;Float;False;True;6;Float;ASEMaterialInspector;0;0;CustomLighting;TreeLeaves;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TreeTransparentCutout;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;1;4;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;0;-1;-1;1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;105;0;111;0
WireConnection;106;0;105;0
WireConnection;64;0;107;0
WireConnection;64;1;62;0
WireConnection;65;0;64;0
WireConnection;52;0;47;0
WireConnection;72;0;109;0
WireConnection;72;1;68;0
WireConnection;70;0;67;0
WireConnection;70;1;66;0
WireConnection;54;0;52;0
WireConnection;53;0;52;0
WireConnection;74;0;70;0
WireConnection;74;1;69;0
WireConnection;48;0;53;0
WireConnection;48;1;54;0
WireConnection;78;0;72;0
WireConnection;78;1;73;0
WireConnection;75;0;74;0
WireConnection;56;0;17;0
WireConnection;56;1;48;0
WireConnection;84;0;78;0
WireConnection;15;0;16;0
WireConnection;15;1;56;0
WireConnection;15;2;18;0
WireConnection;15;3;19;0
WireConnection;90;0;84;0
WireConnection;81;0;76;1
WireConnection;81;1;75;0
WireConnection;81;2;79;0
WireConnection;29;0;30;0
WireConnection;29;1;3;0
WireConnection;94;0;88;1
WireConnection;94;1;87;0
WireConnection;92;0;90;0
WireConnection;92;1;89;0
WireConnection;86;0;81;0
WireConnection;86;1;29;0
WireConnection;6;4;15;0
WireConnection;95;0;94;0
WireConnection;91;0;86;0
WireConnection;28;0;6;0
WireConnection;28;1;31;0
WireConnection;98;0;92;0
WireConnection;98;1;95;0
WireConnection;24;1;25;0
WireConnection;24;2;26;0
WireConnection;24;3;27;2
WireConnection;61;0;91;0
WireConnection;61;1;98;0
WireConnection;22;0;28;0
WireConnection;22;1;23;0
WireConnection;7;0;99;0
WireConnection;7;9;3;4
WireConnection;7;10;3;4
WireConnection;7;13;61;0
WireConnection;7;11;22;0
ASEEND*/
//CHKSM=50C909E1D21199C7186A263339E8142473100DF7