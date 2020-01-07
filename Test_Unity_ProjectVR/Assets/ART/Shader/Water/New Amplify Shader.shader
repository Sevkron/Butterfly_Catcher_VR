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
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Watercolor("Water color", Color) = (0.2313726,0.5333334,0.6901961,0)
		_topcolor("top color", Color) = (0.2745098,0.6784314,0.8156863,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _Waveheight;
		uniform float _wavespeed;
		uniform float2 _Wavestretch;
		uniform float _WaveTile;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _Watercolor;
		uniform float4 _topcolor;
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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_3 = (4.5).xxxx;
			return temp_cast_3;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float temp_output_10_0 = ( _Time.y * _wavespeed );
			float2 _Wavedirection = float2(-1,0);
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float4 appendResult12 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
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
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			o.Normal = UnpackNormal( tex2D( _TextureSample0, uv_TextureSample0 ) );
			float temp_output_10_0 = ( _Time.y * _wavespeed );
			float2 _Wavedirection = float2(-1,0);
			float3 ase_worldPos = i.worldPos;
			float4 appendResult12 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float4 WorlSpaceTile13 = appendResult12;
			float4 WaveTileUvs23 = ( ( WorlSpaceTile13 * float4( _Wavestretch, 0.0 , 0.0 ) ) * _WaveTile );
			float2 panner4 = ( temp_output_10_0 * _Wavedirection + WaveTileUvs23.xy);
			float simplePerlin2D1 = snoise( panner4 );
			simplePerlin2D1 = simplePerlin2D1*0.5 + 0.5;
			float2 panner28 = ( temp_output_10_0 * _Wavedirection + ( WaveTileUvs23 * float4( 0.1,0.1,0,0 ) ).xy);
			float simplePerlin2D29 = snoise( panner28 );
			simplePerlin2D29 = simplePerlin2D29*0.5 + 0.5;
			float temp_output_53_0 = ( simplePerlin2D1 * simplePerlin2D29 );
			float WavePattern33 = temp_output_53_0;
			float4 lerpResult46 = lerp( _Watercolor , _topcolor , WavePattern33);
			float4 Wateralbedo54 = lerpResult46;
			float4 temp_output_56_0 = Wateralbedo54;
			o.Albedo = temp_output_56_0.rgb;
			o.Emission = temp_output_56_0.rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
13;419;1901;607;4372.922;1595.702;2.444654;True;False
Node;AmplifyShaderEditor.CommentaryNode;14;-3642.186,-1037.64;Inherit;False;988.9202;316.8555;Comment;3;12;13;11;WorldSpaceUVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;11;-3592.186,-987.6401;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;38;-3655.101,-422.6302;Inherit;False;2785.969;648.7327;Comment;6;27;21;34;22;35;36;Waves UVs and Height;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;-3211.411,-983.2123;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-2899.266,-978.7845;Inherit;True;WorlSpaceTile;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;27;-3587.515,-289.2464;Inherit;False;1307.552;452.5913;;6;15;17;19;16;18;23;Wave Tiles UVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;17;-3510.949,-10.97184;Inherit;False;Property;_Wavestretch;Wave stretch;2;0;Create;True;0;0;False;0;0.15,0.02;0.23,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;15;-3537.515,-236.779;Inherit;True;13;WorlSpaceTile;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-3031.395,-239.2464;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-3014.257,-21.63916;Inherit;False;Property;_WaveTile;Wave Tile;1;0;Create;True;0;0;False;0;0.23;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2771.541,-139.3721;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;39;-3580.968,336.9135;Inherit;False;1820.246;1570.999;Comment;13;32;8;9;30;24;10;7;4;28;29;1;33;53;Wave Pattern;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-2522.963,-140.7901;Inherit;True;WaveTileUvs;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;8;-3489.623,1217.948;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-3505.968,1718.913;Inherit;True;23;WaveTileUvs;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-3498.297,1486.398;Inherit;True;Property;_wavespeed;wave speed;0;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;7;-3486.478,909.4965;Inherit;True;Constant;_Wavedirection;Wave direction;0;0;Create;True;0;0;False;0;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-3160.444,1250.868;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-3111.418,1665.928;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.1,0.1,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-3517.411,481.9844;Inherit;True;23;WaveTileUvs;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;4;-2919.67,460.3095;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;28;-2805.555,875.5649;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;1;-2533.186,386.9135;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;29;-2491.9,777.136;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-2225.685,546.299;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-2003.722,603.7559;Inherit;False;WavePattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;55;-2513.751,-1396.715;Inherit;False;1025.351;678.3166;Comment;5;47;44;45;46;54;Water color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-2000.848,-25.96077;Inherit;False;Property;_Waveheight;Wave height;3;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;21;-2013.997,-372.6302;Inherit;True;Constant;_Waveup;Wave up;2;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;44;-2463.751,-1154.002;Inherit;False;Property;_topcolor;top color;7;0;Create;True;0;0;False;0;0.2745098,0.6784314,0.8156863,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;45;-2463.452,-1346.715;Inherit;False;Property;_Watercolor;Water color;6;0;Create;True;0;0;False;0;0.2313726,0.5333334,0.6901961,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1690.134,-242.3747;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-2443.773,-948.3986;Inherit;True;33;WavePattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;46;-2134.508,-1190.823;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-1375.521,-32.20079;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-1731.402,-1141.6;Inherit;False;Wateralbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-1112.133,-31.89758;Inherit;True;WaveHeight;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DepthFade;57;-1275.547,-1060.322;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-508.083,110.5274;Inherit;True;36;WaveHeight;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-419.3159,-134.397;Float;True;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;False;0;0.9;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-118.9828,-371.6541;Inherit;False;54;Wateralbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;41;-496.8864,-350.4256;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;-472.3225,331.7188;Inherit;True;Constant;_Tesselation;Tesselation;2;0;Create;True;0;0;False;0;4.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-950.4072,-862.3055;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;146.2972,-168.822;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;New Amplify Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;11;1
WireConnection;12;1;11;3
WireConnection;13;0;12;0
WireConnection;16;0;15;0
WireConnection;16;1;17;0
WireConnection;18;0;16;0
WireConnection;18;1;19;0
WireConnection;23;0;18;0
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;30;0;32;0
WireConnection;4;0;24;0
WireConnection;4;2;7;0
WireConnection;4;1;10;0
WireConnection;28;0;30;0
WireConnection;28;2;7;0
WireConnection;28;1;10;0
WireConnection;1;0;4;0
WireConnection;29;0;28;0
WireConnection;53;0;1;0
WireConnection;53;1;29;0
WireConnection;33;0;53;0
WireConnection;22;0;21;0
WireConnection;22;1;34;0
WireConnection;46;0;45;0
WireConnection;46;1;44;0
WireConnection;46;2;47;0
WireConnection;35;0;22;0
WireConnection;35;1;53;0
WireConnection;54;0;46;0
WireConnection;36;0;35;0
WireConnection;0;0;56;0
WireConnection;0;1;41;0
WireConnection;0;2;56;0
WireConnection;0;4;40;0
WireConnection;0;11;37;0
WireConnection;0;14;20;0
ASEEND*/
//CHKSM=DDBAC6E9F3EF9319B8F53E2AD82DC3CD821507D0