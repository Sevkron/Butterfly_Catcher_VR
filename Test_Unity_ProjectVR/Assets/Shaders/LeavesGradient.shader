// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LeavesGradient"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_MainTex("MainTex", 2D) = "white" {}
		_Metallic("Metallic", Float) = 0
		_Smoothness("Smoothness", Float) = 0
		_MinY("Min Y", Float) = 0
		_MaxY("Max Y", Float) = 0
		_Offset("Offset", Float) = 0
		_TreeOffset1("Tree Offset", Vector) = (0,5,0,0)
		_Power("Power", Float) = 0
		[HDR]_TopColor("Top Color", Color) = (0,0,0,0)
		_TreeInstanceScale("_TreeInstanceScale", Vector) = (0,0,0,0)
		_SecondaryFactor1("SecondaryFactor", Float) = 0
		_PrimaryFactor1("PrimaryFactor", Float) = 0
		_EdgeFlutter1("EdgeFlutter", Float) = 1
		_BranchPhase1("BranchPhase", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TreeTransparentCutout"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
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

		uniform float _BranchPhase1;
		uniform float _EdgeFlutter1;
		uniform float _PrimaryFactor1;
		uniform float _SecondaryFactor1;
		uniform float3 _TreeOffset1;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _TopColor;
		uniform float _Offset;
		uniform float _MinY;
		uniform float _MaxY;
		uniform float _Power;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _Cutoff = 0.5;
		uniform float _EdgeLength;


		float4 WindAnimateVertex1_g6( float4 Pos , float3 Normal , float4 AnimParams )
		{
			return AnimateVertex(Pos,Normal,AnimParams);
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float4 ase_vertex4Pos = v.vertex;
			float4 Pos1_g6 = ase_vertex4Pos;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 Normal1_g6 = ase_vertexNormal;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 normalizeResult57 = normalize( ase_worldPos );
			float4 appendResult66 = (float4(_BranchPhase1 , ( _EdgeFlutter1 * ( (normalizeResult57).x + (normalizeResult57).z ) ) , _PrimaryFactor1 , _SecondaryFactor1));
			float4 AnimParams1_g6 = appendResult66;
			float4 localWindAnimateVertex1_g6 = WindAnimateVertex1_g6( Pos1_g6 , Normal1_g6 , AnimParams1_g6 );
			v.vertex.xyz = ( ( localWindAnimateVertex1_g6 * _TreeInstanceScale ) + float4( _TreeOffset1 , 0.0 ) ).xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			o.Normal = mul( unity_WorldToObject, float4( ase_worldTangent , 0.0 ) ).xyz;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 lerpResult18 = lerp( tex2DNode1 , ( _TopColor + tex2DNode1 ) , pow( saturate( (0.0 + (( ase_vertex3Pos.y + _Offset ) - _MinY) * (1.0 - 0.0) / (_MaxY - _MinY)) ) , _Power ));
			o.Albedo = lerpResult18.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			clip( tex2DNode1.a - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
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
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
1920;1;1906;1011;1240.302;-112.5338;1.574286;True;False
Node;AmplifyShaderEditor.CommentaryNode;55;-1088.87,808.5259;Inherit;False;1942.196;644.2853;Terrain and Wind;16;74;70;69;68;67;66;65;64;63;62;61;60;59;58;57;56;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;56;-1028.902,1020.858;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;57;-848.8104,1051.865;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;59;-691.8104,1005.865;Inherit;False;FLOAT;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;58;-697.7203,1107.251;Inherit;False;FLOAT;2;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;5;-860.8729,-342.7425;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-597.3018,-130.997;Inherit;False;Property;_Offset;Offset;11;0;Create;True;0;0;False;0;0;1.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-522.0884,1037.732;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-355.0645,990.9954;Float;False;Property;_EdgeFlutter1;EdgeFlutter;19;0;Create;True;0;0;False;0;1;33.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-196.8313,1057.548;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-288.8624,881.7623;Float;False;Property;_BranchPhase1;BranchPhase;20;0;Create;True;0;0;False;0;0;11.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-270.1624,1294.963;Float;False;Property;_SecondaryFactor1;SecondaryFactor;17;0;Create;True;0;0;False;0;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-506.9767,-305.7241;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-678.7422,-649.2552;Inherit;False;Property;_MinY;Min Y;9;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-631.3587,-495.2585;Inherit;False;Property;_MaxY;Max Y;10;0;Create;True;0;0;False;0;0;10.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-278.2624,1191.063;Float;False;Property;_PrimaryFactor1;PrimaryFactor;18;0;Create;True;0;0;False;0;0;1.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;8;-289.3083,-624.0823;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;66;-24.5083,1067.189;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector4Node;67;235.2464,1119.897;Float;False;Property;_TreeInstanceScale;_TreeInstanceScale;15;0;Fetch;True;0;0;False;0;0,0,0,0;1,1,1,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-52.39031,-424.1831;Inherit;False;Property;_Power;Power;13;0;Create;True;0;0;False;0;0;17.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;68;171.5381,953.0621;Inherit;False;Terrain Wind Animate Vertex;-1;;6;3bc81bd4568a7094daabf2ccd6a7e125;0;3;2;FLOAT4;0,0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;26;-79.04353,-655.1782;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;224.0439,309.3135;Inherit;True;Property;_MainTex;MainTex;6;0;Create;True;0;0;False;0;-1;None;689ee5dc2b726ff42aa4a37bd8eb5ce2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;17;-336.6919,-243.5331;Inherit;False;Property;_TopColor;Top Color;14;1;[HDR];Create;True;0;0;False;0;0,0,0,0;2.028059,2.297397,0.03251027,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;14;61.62657,-587.0641;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;497.4098,913.2092;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;70;538.6786,1181.948;Float;False;Property;_TreeOffset1;Tree Offset;12;0;Create;True;0;0;False;0;0,5,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-121.985,17.07673;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldToObjectMatrix;29;-403.3248,329.5127;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.VertexTangentNode;28;-495.1306,157.7471;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;75;-1613.612,883.1265;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;27;-33.14061,-301.2819;Inherit;False;Constant;_Color0;Color 0;11;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;35;321.0003,-613.7381;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-224.1555,176.9967;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;674.3235,888.6644;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;18;276.3335,-96.94005;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;71;-1637.612,1218.126;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;175.0521,405.3201;Inherit;False;Property;_Metallic;Metallic;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-125,369;Inherit;False;Property;_Smoothness;Smoothness;8;0;Create;True;0;0;False;0;0;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;38;700.6,-323.8382;Inherit;False;Terrain Wind Value;-1;;7;c7f50c5b53423ac408959a9a25532d8c;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;73;-1642.612,1060.126;Inherit;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;72;-1314.611,1049.126;Float;False;TerrainBillboardTree(Pos, Offset, OffsetZ)@$return@;7;False;3;True;Pos;FLOAT4;0,0,0,0;InOut;;Float;False;True;Offset;FLOAT2;0,0;In;;Float;False;True;OffsetZ;FLOAT;0;In;;Float;False;TerrainBillboardTree;True;False;0;4;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT4;2
Node;AmplifyShaderEditor.Vector4Node;37;348.3001,-399.2381;Inherit;False;Property;_Wind;Wind;16;0;Create;True;0;0;False;0;0,0,0,0;2.07,1.38,0.84,1.47;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;864.5247,-10.93196;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;LeavesGradient;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TreeTransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;5;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;57;0;56;0
WireConnection;59;0;57;0
WireConnection;58;0;57;0
WireConnection;61;0;59;0
WireConnection;61;1;58;0
WireConnection;64;0;60;0
WireConnection;64;1;61;0
WireConnection;11;0;5;2
WireConnection;11;1;12;0
WireConnection;8;0;11;0
WireConnection;8;1;9;0
WireConnection;8;2;10;0
WireConnection;66;0;65;0
WireConnection;66;1;64;0
WireConnection;66;2;62;0
WireConnection;66;3;63;0
WireConnection;68;4;66;0
WireConnection;26;0;8;0
WireConnection;14;0;26;0
WireConnection;14;1;15;0
WireConnection;69;0;68;0
WireConnection;69;1;67;0
WireConnection;16;0;17;0
WireConnection;16;1;1;0
WireConnection;30;0;29;0
WireConnection;30;1;28;0
WireConnection;74;0;69;0
WireConnection;74;1;70;0
WireConnection;18;0;1;0
WireConnection;18;1;16;0
WireConnection;18;2;14;0
WireConnection;72;1;75;0
WireConnection;72;2;73;0
WireConnection;72;3;71;2
WireConnection;0;0;18;0
WireConnection;0;1;30;0
WireConnection;0;3;2;0
WireConnection;0;4;3;0
WireConnection;0;10;1;4
WireConnection;0;11;74;0
ASEEND*/
//CHKSM=566316E61C25FE757B8A4F98388BFB76938026A7