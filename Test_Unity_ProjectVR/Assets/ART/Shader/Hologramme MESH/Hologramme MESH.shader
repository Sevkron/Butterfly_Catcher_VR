// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hologramme MESH"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Linecolor1("Line color", Color) = (0,0.9394503,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
		};

		uniform float4 _Linecolor1;
		uniform float _Cutoff = 0.5;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color76 = IsGammaSpace() ? float4(0,0.7265239,1,0) : float4(0,0.4866935,1,0);
			o.Albedo = color76.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV103 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode103 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV103, 1.5 ) );
			float mulTime78 = _Time.y * 5.0;
			float2 panner79 = ( mulTime78 * float2( 0,0.07 ) + float2( 0,0 ));
			float2 uv_TexCoord81 = i.uv_texcoord * float2( 1,1 ) + panner79;
			float simplePerlin2D83 = snoise( uv_TexCoord81*2.0 );
			simplePerlin2D83 = simplePerlin2D83*0.5 + 0.5;
			float4 Emissiong90 = ( _Linecolor1 * simplePerlin2D83 );
			o.Emission = ( fresnelNode103 + Emissiong90 ).rgb;
			o.Alpha = 1;
			float fresnelNdotV92 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode92 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV92, 1.5 ) );
			float2 temp_cast_2 = (0.6).xx;
			float2 panner51 = ( _Time.y * temp_cast_2 + float2( 0,0 ));
			float2 uv_TexCoord56 = i.uv_texcoord * float2( 40,40 ) + panner51;
			float2 temp_cast_3 = (0.4).xx;
			float2 panner53 = ( _Time.y * temp_cast_3 + float2( 0,0 ));
			float2 uv_TexCoord55 = i.uv_texcoord * float2( 20,20 ) + panner53;
			float2 temp_cast_4 = (0.6).xx;
			float2 panner52 = ( _Time.y * temp_cast_4 + float2( 0,0 ));
			float2 uv_TexCoord57 = i.uv_texcoord * float2( 8,8 ) + panner52;
			float2 temp_cast_5 = (-0.3).xx;
			float2 panner48 = ( _Time.y * temp_cast_5 + float2( 0,0 ));
			float2 uv_TexCoord58 = i.uv_texcoord * float2( 100,100 ) + panner48;
			float Lineg87 = ( ( step( frac( uv_TexCoord56.y ) , 0.3 ) * 1.0 ) + ( step( frac( uv_TexCoord55.y ) , 0.15 ) * 1.0 ) + ( step( frac( uv_TexCoord57.y ) , 0.2 ) * 1.0 ) + ( step( frac( uv_TexCoord58.y ) , 0.2 ) * 1.0 ) );
			clip( ( fresnelNode92 + Lineg87 ) - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
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
1921;1;1918;1017;3398.41;-665.2328;1.214699;True;False
Node;AmplifyShaderEditor.CommentaryNode;86;-3303.734,534.9198;Inherit;False;2443.422;1360.469;Comment;38;75;74;71;73;72;66;68;64;63;69;65;70;67;59;61;62;60;55;56;57;58;53;48;51;50;49;54;47;52;46;44;43;42;41;40;39;45;87;Line hologramm;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;40;-3244.458,1124.865;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-3225.145,1345.861;Inherit;False;Constant;_Float13;Float 12;3;0;Create;True;0;0;False;0;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;45;-3231.246,1441.573;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;42;-3174.116,1741.975;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;89;-3288.77,-389.3934;Inherit;False;1943.704;780.7249;Comment;10;84;82;83;81;85;79;80;78;77;90;Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;44;-3253.734,799.1354;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-3247.633,703.4235;Inherit;False;Constant;_Float11;Float 10;3;0;Create;True;0;0;False;0;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-3168.016,1646.263;Inherit;False;Constant;_speed2;speed1;3;0;Create;True;0;0;False;0;-0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-3238.357,1029.153;Inherit;False;Constant;_Float12;Float 11;3;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;52;-2889.281,1432.767;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;48;-2832.152,1733.169;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;49;-2877.406,956.2091;Inherit;False;Constant;_Vector3;Vector 2;3;0;Create;True;0;0;False;0;20,20;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;51;-2911.769,790.3294;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-3238.77,121.5609;Inherit;True;Constant;_Float3;Float 2;0;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;50;-2839.044,1588.024;Inherit;False;Constant;_Vector4;Vector 3;3;0;Create;True;0;0;False;0;100,100;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;54;-2885.728,652.0913;Inherit;False;Constant;_Vector1;Vector 0;3;0;Create;True;0;0;False;0;40,40;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;53;-2902.493,1116.059;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;47;-2864.194,1272.916;Inherit;False;Constant;_Vector5;Vector 4;3;0;Create;True;0;0;False;0;8,8;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;56;-2665.75,643.3619;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-2619.069,1579.294;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;55;-2652.719,947.4797;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-2639.507,1264.187;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;78;-3050.77,122.5609;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;79;-2789.759,91.56848;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.07;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;62;-2355.921,910.8164;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;61;-2322.274,1542.631;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;60;-2368.953,606.6987;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;80;-2776.771,-159.4391;Inherit;False;Constant;_Vector2;Vector 1;0;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FractNode;59;-2342.707,1227.524;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;81;-2525.771,-195.439;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;85;-2421.556,-339.3934;Inherit;False;Constant;_Float4;Float 3;0;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;64;-2110.737,1520.852;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-2078.726,1738.549;Inherit;False;Constant;_Float1;Float 0;3;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-2075.782,1420.467;Inherit;False;Constant;_Float9;Float 8;3;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;65;-2131.171,1205.745;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;67;-2157.416,584.9198;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;66;-2144.385,889.0375;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-2122.966,1122.194;Inherit;False;Constant;_Float8;Float 7;3;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-2120.471,798.679;Inherit;False;Constant;_Float2;Float 1;3;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-1863.514,1521.448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-1897.966,876.1934;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-1838.903,608.473;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-1883.561,1217.975;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;82;-2223.922,31.3187;Inherit;False;Property;_Linecolor1;Line color;1;0;Create;True;0;0;False;0;0,0.9394503,1,0;0,0.9394503,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;83;-2234.035,-276.3332;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-1916.7,-170.2918;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-1581.457,585.4591;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-743.5424,-208.6611;Inherit;False;Constant;_Float14;Float 0;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-1010.596,161.5969;Inherit;False;Constant;_Float5;Float 5;2;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;-1215.301,636.4092;Inherit;False;Lineg;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-1008.596,80.59692;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-745.5424,-127.6612;Inherit;False;Constant;_Float7;Float 5;2;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-749.5424,-1.661179;Inherit;False;Constant;_Float10;Float 6;2;0;Create;True;0;0;False;0;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-1014.596,287.5969;Inherit;False;Constant;_Float6;Float 6;2;0;Create;True;0;0;False;0;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;-1619.286,-148.9746;Inherit;False;Emissiong;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;103;-503.5423,-202.6611;Inherit;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-462.8831,-11.75168;Inherit;False;90;Emissiong;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;92;-768.5962,86.59692;Inherit;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;88;-705.3081,281.3413;Inherit;False;87;Lineg;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;99;-509.5962,211.5969;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;108;-231.6932,-57.51274;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;76;-260.7048,-489.1204;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;False;0;0,0.7265239,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Hologramme MESH;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;TransparentCutout;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;0;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;52;2;39;0
WireConnection;52;1;45;0
WireConnection;48;2;41;0
WireConnection;48;1;42;0
WireConnection;51;2;46;0
WireConnection;51;1;44;0
WireConnection;53;2;43;0
WireConnection;53;1;40;0
WireConnection;56;0;54;0
WireConnection;56;1;51;0
WireConnection;58;0;50;0
WireConnection;58;1;48;0
WireConnection;55;0;49;0
WireConnection;55;1;53;0
WireConnection;57;0;47;0
WireConnection;57;1;52;0
WireConnection;78;0;77;0
WireConnection;79;1;78;0
WireConnection;62;0;55;2
WireConnection;61;0;58;2
WireConnection;60;0;56;2
WireConnection;59;0;57;2
WireConnection;81;0;80;0
WireConnection;81;1;79;0
WireConnection;64;0;61;0
WireConnection;65;0;59;0
WireConnection;67;0;60;0
WireConnection;66;0;62;0
WireConnection;72;0;64;0
WireConnection;72;1;68;0
WireConnection;74;0;66;0
WireConnection;74;1;69;0
WireConnection;71;0;67;0
WireConnection;71;1;70;0
WireConnection;73;0;65;0
WireConnection;73;1;63;0
WireConnection;83;0;81;0
WireConnection;83;1;85;0
WireConnection;84;0;82;0
WireConnection;84;1;83;0
WireConnection;75;0;71;0
WireConnection;75;1;74;0
WireConnection;75;2;73;0
WireConnection;75;3;72;0
WireConnection;87;0;75;0
WireConnection;90;0;84;0
WireConnection;103;1;102;0
WireConnection;103;2;100;0
WireConnection;103;3;101;0
WireConnection;92;1;93;0
WireConnection;92;2;94;0
WireConnection;92;3;95;0
WireConnection;99;0;92;0
WireConnection;99;1;88;0
WireConnection;108;0;103;0
WireConnection;108;1;91;0
WireConnection;0;0;76;0
WireConnection;0;2;108;0
WireConnection;0;10;99;0
ASEEND*/
//CHKSM=950198F30C2D961A8ECC9F72F208C4EBE22CECC7