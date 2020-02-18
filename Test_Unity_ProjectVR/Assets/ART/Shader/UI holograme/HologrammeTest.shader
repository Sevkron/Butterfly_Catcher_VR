// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HologrammeTest"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Linecolor("Line color", Color) = (0,0.9394503,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Linecolor;
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
			float4 color61 = IsGammaSpace() ? float4(0,0.4942791,1,0) : float4(0,0.2087842,1,0);
			float mulTime21 = _Time.y * 5.0;
			float2 panner26 = ( mulTime21 * float2( 0,0.07 ) + float2( 0,0 ));
			float2 uv_TexCoord29 = i.uv_texcoord * float2( 1,1 ) + panner26;
			float simplePerlin2D42 = snoise( uv_TexCoord29*2.0 );
			simplePerlin2D42 = simplePerlin2D42*0.5 + 0.5;
			float2 temp_cast_0 = (0.6).xx;
			float2 panner11 = ( _Time.y * temp_cast_0 + float2( 0,0 ));
			float2 uv_TexCoord19 = i.uv_texcoord * float2( 40,40 ) + panner11;
			float2 temp_cast_1 = (0.4).xx;
			float2 panner9 = ( _Time.y * temp_cast_1 + float2( 0,0 ));
			float2 uv_TexCoord18 = i.uv_texcoord * float2( 5,5 ) + panner9;
			float2 temp_cast_2 = (0.6).xx;
			float2 panner10 = ( _Time.y * temp_cast_2 + float2( 0,0 ));
			float2 uv_TexCoord20 = i.uv_texcoord * float2( 2,2 ) + panner10;
			float2 temp_cast_3 = (-0.3).xx;
			float2 panner14 = ( _Time.y * temp_cast_3 + float2( 0,0 ));
			float2 uv_TexCoord22 = i.uv_texcoord * float2( 100,100 ) + panner14;
			float temp_output_45_0 = ( ( step( frac( uv_TexCoord19.y ) , 0.3 ) * 0.3 ) + ( step( frac( uv_TexCoord18.y ) , 0.15 ) * 0.4 ) + ( step( frac( uv_TexCoord20.y ) , 0.2 ) * 0.0 ) + ( step( frac( uv_TexCoord22.y ) , 0.1 ) * 0.2 ) );
			o.Albedo = ( color61 + ( ( _Linecolor * simplePerlin2D42 ) * temp_output_45_0 ) ).rgb;
			o.Alpha = 1;
			clip( temp_output_45_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
2019;75;1906;1011;3470.211;1047.377;2.586467;True;True
Node;AmplifyShaderEditor.RangedFloatNode;1;-3096.115,1559.192;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;False;0;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;-3115.428,1338.196;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-3038.986,1859.594;Inherit;False;Constant;_speed1;speed1;3;0;Create;True;0;0;False;0;-0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;-3045.087,1955.306;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-3109.327,1242.484;Inherit;False;Constant;_Float5;Float 5;3;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-3124.704,1012.467;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;7;-3102.216,1654.904;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-3118.603,916.7549;Inherit;False;Constant;_Float10;Float 10;3;0;Create;True;0;0;False;0;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;15;-2735.165,1486.247;Inherit;False;Constant;_Vector4;Vector 4;3;0;Create;True;0;0;False;0;2,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;14;-2703.123,1946.5;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;9;-2773.463,1329.39;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;10;-2760.251,1646.098;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;17;-2748.376,1169.54;Inherit;False;Constant;_Vector3;Vector 3;3;0;Create;True;0;0;False;0;5,5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;16;-2934.365,239.6265;Inherit;True;Constant;_Float3;Float 3;0;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;13;-2756.698,865.4227;Inherit;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;False;0;40,40;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;12;-2710.014,1801.355;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;100,100;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;11;-2782.74,1003.661;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-2523.688,1160.811;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-2536.719,856.6934;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-2510.477,1477.518;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;21;-2746.365,240.6265;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-2490.039,1792.625;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;28;-2239.922,820.0302;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;23;-2472.366,-41.37357;Inherit;False;Constant;_Vector2;Vector 2;0;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FractNode;24;-2226.89,1124.148;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;25;-2193.243,1755.962;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;27;-2213.677,1440.855;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;26;-2485.354,209.634;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.07;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1993.936,1335.525;Inherit;False;Constant;_Float7;Float 7;3;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-2221.366,-77.37334;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;32;-1949.696,1951.88;Inherit;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;False;0;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1991.441,1012.01;Inherit;False;Constant;_Float2;Float 2;3;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;33;-2028.386,798.2512;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1946.752,1633.798;Inherit;False;Constant;_Float6;Float 6;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-2117.151,-221.3277;Inherit;False;Constant;_Float4;Float 4;0;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;38;-2015.355,1102.369;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;34;-1981.707,1734.183;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;35;-2002.141,1419.076;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1734.484,1734.779;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-1709.873,821.8044;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;40;-1919.518,149.3841;Inherit;False;Property;_Linecolor;Line color;1;0;Create;True;0;0;False;0;0,0.9394503,1,0;0,0.9638113,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-1754.531,1431.306;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1768.936,1089.525;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;42;-1929.631,-158.2676;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-1586.401,-134.6197;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;-1452.427,798.7905;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;61;-987.2024,-180.9102;Inherit;False;Constant;_Color0;Color 0;2;0;Create;True;0;0;False;0;0,0.4942791,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-938.5015,199.5517;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;60;-908.3721,763.6392;Inherit;False;Constant;_Color1;Color 1;2;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-469.9089,0.1425376;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;HologrammeTest;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;TransparentCutout;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;14;2;3;0
WireConnection;14;1;4;0
WireConnection;9;2;5;0
WireConnection;9;1;2;0
WireConnection;10;2;1;0
WireConnection;10;1;7;0
WireConnection;11;2;8;0
WireConnection;11;1;6;0
WireConnection;18;0;17;0
WireConnection;18;1;9;0
WireConnection;19;0;13;0
WireConnection;19;1;11;0
WireConnection;20;0;15;0
WireConnection;20;1;10;0
WireConnection;21;0;16;0
WireConnection;22;0;12;0
WireConnection;22;1;14;0
WireConnection;28;0;19;2
WireConnection;24;0;18;2
WireConnection;25;0;22;2
WireConnection;27;0;20;2
WireConnection;26;1;21;0
WireConnection;29;0;23;0
WireConnection;29;1;26;0
WireConnection;33;0;28;0
WireConnection;38;0;24;0
WireConnection;34;0;25;0
WireConnection;35;0;27;0
WireConnection;41;0;34;0
WireConnection;41;1;32;0
WireConnection;39;0;33;0
WireConnection;39;1;30;0
WireConnection;43;0;35;0
WireConnection;43;1;36;0
WireConnection;44;0;38;0
WireConnection;44;1;31;0
WireConnection;42;0;29;0
WireConnection;42;1;37;0
WireConnection;46;0;40;0
WireConnection;46;1;42;0
WireConnection;45;0;39;0
WireConnection;45;1;44;0
WireConnection;45;2;43;0
WireConnection;45;3;41;0
WireConnection;47;0;46;0
WireConnection;47;1;45;0
WireConnection;63;0;61;0
WireConnection;63;1;47;0
WireConnection;0;0;63;0
WireConnection;0;10;45;0
ASEEND*/
//CHKSM=6991A41EDF7A82D29E46A7588612096F86FB9346