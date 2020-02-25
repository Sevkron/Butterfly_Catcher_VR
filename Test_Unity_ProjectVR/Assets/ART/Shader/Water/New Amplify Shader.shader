// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "New Amplify Shader"
{
	Properties
	{
		_wavespeed("wave speed", Float) = 1
		_WaveTile("Wave Tile", Float) = 0.23
		_Wavestretch("Wave stretch", Vector) = (0.15,0.02,0,0)
		_Waveheight("Wave height", Float) = 1
		_Smoothness("Smoothness", Float) = 0.9
		_Watercolor("Water color", Color) = (0,0.5666108,1,0)
		_topcolor("top color", Color) = (0,0.7484279,1,1)
		_Egepower("Ege power", Range( 0 , 1)) = 1
		_NormalMap("Normal Map", 2D) = "white" {}
		_Edgedistance("Edge distance", Float) = 1
		_Pandirection("Pan direction", Vector) = (1,0,0,0)
		_Normaltile("Normal tile", Float) = 5
		_seafoam("seafoam", 2D) = "white" {}
		_Edgefoamtile("Edge foam tile", Float) = 1
		_sEAfoamtile("sEA foam tile", Float) = 1
		_Refrectamount("Refrect amount", Float) = 0.1
		_Depthfade("Depthfade", Float) = -4
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
		};

		uniform float _Waveheight;
		uniform float _wavespeed;
		uniform float2 _Wavestretch;
		uniform float _WaveTile;
		uniform sampler2D _NormalMap;
		uniform float2 _Pandirection;
		uniform float _Normaltile;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _Refrectamount;
		uniform float4 _Watercolor;
		uniform float4 _topcolor;
		uniform sampler2D _seafoam;
		uniform float _sEAfoamtile;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Depthfade;
		uniform float _Edgefoamtile;
		uniform float _Edgedistance;
		uniform float _Egepower;
		uniform float _Smoothness;


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


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		float2 voronoihash128( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi128( float2 v, float time, inout float2 id, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mr = 0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash128( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 Tesselation155 = UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, 0.0,80.0,( _Waveheight * 4.5 ));
			return Tesselation155;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float temp_output_10_0 = ( _Time.y * _wavespeed );
			float2 _Wavedirection = float2(-1,0);
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float4 appendResult12 = (float4(ase_worldPos.z , ase_worldPos.x , 0.0 , 0.0));
			float4 WorlSpaceTile13 = appendResult12;
			float4 WaveTileUvs23 = ( ( WorlSpaceTile13 * float4( _Wavestretch, 0.0 , 0.0 ) ) * _WaveTile );
			float2 panner4 = ( temp_output_10_0 * _Wavedirection + WaveTileUvs23.xy);
			float simplePerlin2D1 = snoise( panner4 );
			simplePerlin2D1 = simplePerlin2D1*0.5 + 0.5;
			float2 panner28 = ( temp_output_10_0 * _Wavedirection + ( WaveTileUvs23 * float4( 0.1,0.1,0,0 ) ).xy);
			float simplePerlin2D29 = snoise( panner28 );
			simplePerlin2D29 = simplePerlin2D29*0.5 + 0.5;
			float temp_output_53_0 = ( simplePerlin2D1 * simplePerlin2D29 );
			float3 WaveHeight36 = ( ( float3(0,1,0) * _Waveheight ) * temp_output_53_0 );
			v.vertex.xyz += WaveHeight36;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float4 appendResult12 = (float4(ase_worldPos.z , ase_worldPos.x , 0.0 , 0.0));
			float4 WorlSpaceTile13 = appendResult12;
			float4 temp_output_73_0 = ( WorlSpaceTile13 * _Normaltile );
			float2 panner77 = ( 1.0 * _Time.y * ( _Pandirection * -0.05 ) + temp_output_73_0.xy);
			float2 panner78 = ( 1.0 * _Time.y * ( ( -0.05 * 3.0 ) * float2( -1,0 ) ) + ( temp_output_73_0 * ( _Normaltile * 0.5 ) ).xy);
			float3 Normal88 = BlendNormals( UnpackScaleNormal( tex2D( _NormalMap, panner77 ), 0.2636661 ) , UnpackScaleNormal( tex2D( _NormalMap, panner78 ), 0.2636661 ) );
			o.Normal = Normal88;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor136 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( float3( (ase_grabScreenPosNorm).xy ,  0.0 ) + ( _Refrectamount * Normal88 ) ).xy);
			float4 clampResult137 = clamp( screenColor136 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 Refraction138 = clampResult137;
			float time128 = 0.0;
			float2 panner119 = ( 1.0 * _Time.y * float2( -0.2,0 ) + ( WorlSpaceTile13 * 0.05 ).xy);
			float2 coords128 = panner119 * 1.0;
			float2 id128 = 0;
			float voroi128 = voronoi128( coords128, time128,id128, 0 );
			float4 Seafoam111 = ( tex2D( _seafoam, ( ( WorlSpaceTile13 / 10.0 ) * _sEAfoamtile ).xy ) * voroi128 );
			float temp_output_10_0 = ( _Time.y * _wavespeed );
			float2 _Wavedirection = float2(-1,0);
			float4 WaveTileUvs23 = ( ( WorlSpaceTile13 * float4( _Wavestretch, 0.0 , 0.0 ) ) * _WaveTile );
			float2 panner4 = ( temp_output_10_0 * _Wavedirection + WaveTileUvs23.xy);
			float simplePerlin2D1 = snoise( panner4 );
			simplePerlin2D1 = simplePerlin2D1*0.5 + 0.5;
			float2 panner28 = ( temp_output_10_0 * _Wavedirection + ( WaveTileUvs23 * float4( 0.1,0.1,0,0 ) ).xy);
			float simplePerlin2D29 = snoise( panner28 );
			simplePerlin2D29 = simplePerlin2D29*0.5 + 0.5;
			float temp_output_53_0 = ( simplePerlin2D1 * simplePerlin2D29 );
			float WavePattern33 = temp_output_53_0;
			float clampResult114 = clamp( WavePattern33 , 0.0 , 1.0 );
			float4 lerpResult46 = lerp( _Watercolor , ( _topcolor + Seafoam111 ) , clampResult114);
			float4 Wateralbedo54 = lerpResult46;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth143 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth143 = abs( ( screenDepth143 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Depthfade ) );
			float clampResult145 = clamp( distanceDepth143 , 0.0 , 1.0 );
			float Depth146 = clampResult145;
			float4 lerpResult147 = lerp( Refraction138 , Wateralbedo54 , Depth146);
			o.Albedo = lerpResult147.rgb;
			float screenDepth57 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth57 = abs( ( screenDepth57 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Edgedistance ) );
			float4 clampResult66 = clamp( ( ( tex2D( _seafoam, ( ( WorlSpaceTile13 / 10.0 ) * _Edgefoamtile ).xy ) + ( 1.0 - distanceDepth57 ) ) * _Egepower ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 Edge62 = clampResult66;
			o.Emission = Edge62.rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
1920;14;1906;1005;994.4159;804.7321;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;14;-5720.251,-1019.952;Inherit;False;988.9202;316.8555;Comment;3;12;13;11;WorldSpaceUVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;11;-5670.251,-998.9526;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;38;-5726.444,-554.0135;Inherit;False;2900.726;643.951;Comment;6;36;35;22;21;34;27;Waves UVs and Height;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;-5289.477,-965.5248;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-4977.332,-961.097;Inherit;True;WorlSpaceTile;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;27;-5658.857,-420.6297;Inherit;False;1307.552;452.5913;;6;15;17;19;16;18;23;Wave Tiles UVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;15;-5608.857,-368.1623;Inherit;True;13;WorlSpaceTile;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;17;-5582.291,-142.3552;Inherit;False;Property;_Wavestretch;Wave stretch;2;0;Create;True;0;0;False;0;0.15,0.02;0.23,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;93;-3912.203,947.4302;Inherit;False;3022.353;1073.979;Comment;19;72;70;74;75;76;73;77;82;83;78;80;79;81;84;86;41;87;85;88;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-3802.101,1047.628;Inherit;False;13;WorlSpaceTile;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-5085.599,-153.0225;Inherit;False;Property;_WaveTile;Wave Tile;1;0;Create;True;0;0;False;0;0.23;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-5102.737,-370.6297;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-3792.102,1163.881;Inherit;False;Property;_Normaltile;Normal tile;11;0;Create;True;0;0;False;0;5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-3109.407,1300.746;Inherit;True;Constant;_NormalSpeed;Normal Speed;9;0;Create;True;0;0;False;0;-0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-3481.03,1057.769;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;79;-3096.819,997.4302;Inherit;True;Property;_Pandirection;Pan direction;10;0;Create;True;0;0;False;0;1,0;-1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;80;-2956.626,1717.409;Inherit;True;Constant;_PanD2;Pan D2;9;0;Create;True;0;0;False;0;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-2894.212,1421.839;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-3589.446,1568.657;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-4842.883,-270.7555;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-3251.15,1555.167;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;39;-5830.174,249.8474;Inherit;False;1820.246;1570.999;Comment;13;32;8;9;30;24;10;7;4;28;29;1;33;53;Wave Pattern;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-2761.745,1086.042;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-2634.261,1723.567;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-4594.304,-272.1736;Inherit;True;WaveTileUvs;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;112;-4496.014,-2554.044;Inherit;False;1601.732;702.313;Comment;12;111;129;104;128;119;108;107;121;109;106;110;122;Sea foam;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-2347.437,1326.026;Inherit;False;Constant;_NormalStrength;Normal Strength;9;0;Create;True;0;0;False;0;0.2636661;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;78;-2362.932,1524.85;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;-4446.014,-2504.044;Inherit;False;13;WorlSpaceTile;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;77;-2412.762,1031.98;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;70;-3862.203,1426.836;Inherit;True;Property;_NormalMap;Normal Map;8;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-5747.503,1399.332;Inherit;True;Property;_wavespeed;wave speed;0;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-4393.411,-2078.067;Inherit;False;Constant;_Foammask;Foam mask;15;0;Create;True;0;0;False;0;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;8;-5738.829,1130.882;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-5755.174,1631.847;Inherit;True;23;WaveTileUvs;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-4409.614,-2349.944;Inherit;False;Constant;_Float1;Float 1;12;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-5360.625,1578.862;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.1,0.1,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-5409.65,1163.802;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-4159.712,-2346.344;Inherit;False;Property;_sEAfoamtile;sEA foam tile;14;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-5766.617,394.9184;Inherit;True;23;WaveTileUvs;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;7;-5735.684,822.4305;Inherit;True;Constant;_Wavedirection;Wave direction;0;0;Create;True;0;0;False;0;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;87;-2003.395,1457.221;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;41;-2007.87,1085.758;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;-4186.077,-2138.719;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;107;-4127.711,-2498.944;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;103;-4514.74,-1769.146;Inherit;False;1256.285;565.3545;Comment;8;95;96;100;98;99;101;97;102;eDGE FOAM;1,1,1,1;0;0
Node;AmplifyShaderEditor.BlendNormalsNode;85;-1562.477,1251.61;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;28;-5054.761,788.4989;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;95;-4157.804,-1706.283;Inherit;True;Property;_seafoam;seafoam;12;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;-3911.713,-2495.944;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;119;-3917.405,-2132.926;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.2,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;4;-5168.876,373.2435;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-4428.34,-1322.391;Inherit;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;88;-1132.85,1311.799;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;140;-3163.369,-1749.213;Inherit;False;1723.88;622.765;Comment;9;134;132;130;131;133;135;136;137;138;Refraction;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;63;-4665.855,-1025.642;Inherit;False;1852.354;357.485;Comment;7;62;66;60;59;61;57;58;Edge;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;104;-3697.768,-2399.017;Inherit;True;Property;_TextureSample3;Texture Sample 3;12;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;97;-4464.74,-1476.492;Inherit;False;13;WorlSpaceTile;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;1;-4782.391,299.8474;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;29;-4741.105,690.0701;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;128;-3554.358,-2106.232;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-4474.891,459.233;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-4628.862,-961.5047;Float;True;Property;_Edgedistance;Edge distance;9;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;100;-4146.436,-1471.392;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;134;-3100.583,-1241.448;Inherit;False;88;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GrabScreenPosition;130;-3113.369,-1699.213;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;132;-3099.267,-1497.729;Inherit;True;Property;_Refrectamount;Refrect amount;15;0;Create;True;0;0;False;0;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-3286.632,-2226.46;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-4178.437,-1318.791;Inherit;False;Property;_Edgefoamtile;Edge foam tile;13;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;131;-2810.742,-1671.754;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;111;-3198.299,-2377.463;Inherit;False;Seafoam;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;55;-2699.526,-1023.712;Inherit;False;1559.263;1102.305;Comment;8;54;46;45;47;44;114;115;116;Water color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-2832.472,-1485.902;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DepthFade;57;-4421.071,-963.588;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-3930.438,-1468.392;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;151;-2803.759,-2074.955;Inherit;False;1240.981;206;Comment;4;144;143;145;146;Depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-4252.928,516.6899;Inherit;False;WavePattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;135;-2528.876,-1550.301;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;44;-2649.525,-780.9995;Inherit;False;Property;_topcolor;top color;6;0;Create;True;0;0;False;0;0,0.7484279,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;47;-2642.676,-349.5678;Inherit;True;33;WavePattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-2649.132,-579.8693;Inherit;True;111;Seafoam;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;96;-3772.647,-1719.146;Inherit;True;Property;_TextureSample2;Texture Sample 2;12;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;59;-4166.734,-954.8902;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;158;-3918.256,239.7602;Inherit;False;1280.015;624.2013;Comment;6;20;157;154;153;155;152;Tesselation;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;144;-2753.759,-2002.058;Inherit;False;Property;_Depthfade;Depthfade;16;0;Create;True;0;0;False;0;-4;-4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;115;-2373.412,-795.1934;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;45;-2649.226,-973.7124;Inherit;False;Property;_Watercolor;Water color;5;0;Create;True;0;0;False;0;0,0.5666108,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;114;-2373.411,-561.4879;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;136;-2189.796,-1543.73;Inherit;False;Global;_GrabScreen0;Grab Screen 0;15;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-4072.191,-157.3441;Inherit;False;Property;_Waveheight;Wave height;3;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-3801.989,-782.2808;Inherit;False;Property;_Egepower;Ege power;7;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-3412.45,-1450.871;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;21;-4085.339,-504.0135;Inherit;True;Constant;_Waveup;Wave up;2;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;20;-3868.256,289.7602;Inherit;True;Constant;_Tesselation;Tesselation;2;0;Create;True;0;0;False;0;4.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;143;-2533.166,-2016.121;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;137;-1899.343,-1534.53;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;153;-3596.906,495.3815;Inherit;False;Constant;_Float2;Float 2;18;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;46;-2178.364,-897.7433;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-3761.477,-373.758;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-3493.922,-892.8552;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;-3584.261,298.8215;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-3596.292,601.5324;Inherit;False;Constant;_Float3;Float 3;18;0;Create;True;0;0;False;0;80;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;145;-2044.778,-2024.956;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-3432.518,-158.8026;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;146;-1805.778,-2005.956;Inherit;False;Depth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;138;-1682.489,-1531.901;Inherit;False;Refraction;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-1906.674,-907.7702;Float;True;Wateralbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DistanceBasedTessNode;152;-3331.787,410.0274;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;66;-3277.953,-928.1225;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;148;-642.498,-449.8038;Inherit;False;146;Depth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-3116.533,-163.2809;Inherit;True;WaveHeight;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-3061.76,-971.5523;Inherit;False;Edge;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;155;-2954.956,467.0351;Inherit;False;Tesselation;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-639.5182,-594.4222;Inherit;False;54;Wateralbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;-628.1803,-704.7723;Inherit;False;138;Refraction;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-508.083,110.5274;Inherit;True;36;WaveHeight;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;147;-296.921,-487.9519;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-605.3973,-211.5835;Inherit;False;62;Edge;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;156;-429.5553,363.7177;Inherit;False;155;Tesselation;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-439.8306,-282.4846;Inherit;False;88;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-419.3159,-134.397;Float;True;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;False;0;0.9;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;146.2972,-168.822;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;New Amplify Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;11;3
WireConnection;12;1;11;1
WireConnection;13;0;12;0
WireConnection;16;0;15;0
WireConnection;16;1;17;0
WireConnection;73;0;72;0
WireConnection;73;1;74;0
WireConnection;83;0;82;0
WireConnection;75;0;74;0
WireConnection;18;0;16;0
WireConnection;18;1;19;0
WireConnection;76;0;73;0
WireConnection;76;1;75;0
WireConnection;81;0;79;0
WireConnection;81;1;82;0
WireConnection;84;0;83;0
WireConnection;84;1;80;0
WireConnection;23;0;18;0
WireConnection;78;0;76;0
WireConnection;78;2;84;0
WireConnection;77;0;73;0
WireConnection;77;2;81;0
WireConnection;30;0;32;0
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;87;0;70;0
WireConnection;87;1;78;0
WireConnection;87;5;86;0
WireConnection;41;0;70;0
WireConnection;41;1;77;0
WireConnection;41;5;86;0
WireConnection;121;0;106;0
WireConnection;121;1;122;0
WireConnection;107;0;106;0
WireConnection;107;1;110;0
WireConnection;85;0;41;0
WireConnection;85;1;87;0
WireConnection;28;0;30;0
WireConnection;28;2;7;0
WireConnection;28;1;10;0
WireConnection;108;0;107;0
WireConnection;108;1;109;0
WireConnection;119;0;121;0
WireConnection;4;0;24;0
WireConnection;4;2;7;0
WireConnection;4;1;10;0
WireConnection;88;0;85;0
WireConnection;104;0;95;0
WireConnection;104;1;108;0
WireConnection;1;0;4;0
WireConnection;29;0;28;0
WireConnection;128;0;119;0
WireConnection;53;0;1;0
WireConnection;53;1;29;0
WireConnection;100;0;97;0
WireConnection;100;1;101;0
WireConnection;129;0;104;0
WireConnection;129;1;128;0
WireConnection;131;0;130;0
WireConnection;111;0;129;0
WireConnection;133;0;132;0
WireConnection;133;1;134;0
WireConnection;57;0;58;0
WireConnection;98;0;100;0
WireConnection;98;1;99;0
WireConnection;33;0;53;0
WireConnection;135;0;131;0
WireConnection;135;1;133;0
WireConnection;96;0;95;0
WireConnection;96;1;98;0
WireConnection;59;0;57;0
WireConnection;115;0;44;0
WireConnection;115;1;116;0
WireConnection;114;0;47;0
WireConnection;136;0;135;0
WireConnection;102;0;96;0
WireConnection;102;1;59;0
WireConnection;143;0;144;0
WireConnection;137;0;136;0
WireConnection;46;0;45;0
WireConnection;46;1;115;0
WireConnection;46;2;114;0
WireConnection;22;0;21;0
WireConnection;22;1;34;0
WireConnection;60;0;102;0
WireConnection;60;1;61;0
WireConnection;157;0;34;0
WireConnection;157;1;20;0
WireConnection;145;0;143;0
WireConnection;35;0;22;0
WireConnection;35;1;53;0
WireConnection;146;0;145;0
WireConnection;138;0;137;0
WireConnection;54;0;46;0
WireConnection;152;0;157;0
WireConnection;152;1;153;0
WireConnection;152;2;154;0
WireConnection;66;0;60;0
WireConnection;36;0;35;0
WireConnection;62;0;66;0
WireConnection;155;0;152;0
WireConnection;147;0;142;0
WireConnection;147;1;56;0
WireConnection;147;2;148;0
WireConnection;0;0;147;0
WireConnection;0;1;94;0
WireConnection;0;2;64;0
WireConnection;0;4;40;0
WireConnection;0;11;37;0
WireConnection;0;14;156;0
ASEEND*/
//CHKSM=A5A07E90B2103D41E52DB641F624266ABE05D6D9