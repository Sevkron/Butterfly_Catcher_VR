// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hologramme"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		_Linecolor("Line color", Color) = (0,0.9394503,1,0)
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_OPACITY("OPACITY", Range( 0 , 1)) = 0.7
		_EMISSION("EMISSION", Range( 0 , 20)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		
		Pass
		{
			Name "Default"
		CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			#include "UnityShaderVariables.cginc"

			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform float _EMISSION;
			uniform sampler2D _TextureSample1;
			uniform float4 _TextureSample1_ST;
			uniform float _OPACITY;
			uniform float4 _MainTex_ST;
			uniform float4 _Linecolor;
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
			

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				float2 uv_TextureSample1 = IN.texcoord.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
				float4 color125 = IsGammaSpace() ? float4(0,1,0.9336774,0) : float4(0,1,0.8557073,0);
				float4 appendResult121 = (float4(( _EMISSION * tex2D( _TextureSample1, uv_TextureSample1 ) * color125 ).rgb , _OPACITY));
				float2 uv_MainTex = IN.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float mulTime25 = _Time.y * 5.0;
				float2 panner27 = ( mulTime25 * float2( 0,0.07 ) + float2( 0,0 ));
				float2 uv029 = IN.texcoord.xy * float2( 1,1 ) + panner27;
				float simplePerlin2D30 = snoise( uv029*2.0 );
				simplePerlin2D30 = simplePerlin2D30*0.5 + 0.5;
				float2 temp_cast_1 = (0.6).xx;
				float2 panner75 = ( _Time.y * temp_cast_1 + float2( 0,0 ));
				float2 uv050 = IN.texcoord.xy * float2( 40,40 ) + panner75;
				float2 temp_cast_2 = (0.4).xx;
				float2 panner72 = ( _Time.y * temp_cast_2 + float2( 0,0 ));
				float2 uv056 = IN.texcoord.xy * float2( 5,5 ) + panner72;
				float2 temp_cast_3 = (0.6).xx;
				float2 panner84 = ( _Time.y * temp_cast_3 + float2( 0,0 ));
				float2 uv085 = IN.texcoord.xy * float2( 2,2 ) + panner84;
				float2 temp_cast_4 = (-0.3).xx;
				float2 panner78 = ( _Time.y * temp_cast_4 + float2( 0,0 ));
				float2 uv062 = IN.texcoord.xy * float2( 100,100 ) + panner78;
				
				half4 color = ( appendResult121 + ( tex2D( _MainTex, uv_MainTex ) * IN.color * saturate( ( ( _Linecolor * simplePerlin2D30 ) * ( ( step( frac( uv050.y ) , 0.3 ) * 0.3 ) + ( step( frac( uv056.y ) , 0.15 ) * 0.4 ) + ( step( frac( uv085.y ) , 0.2 ) * 0.0 ) + ( step( frac( uv062.y ) , 0.1 ) * 0.2 ) ) ) ) ) );
				
				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=17500
2108;162;1362;979;2827.856;553.1745;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;81;-2703.593,1236.3;Inherit;False;Constant;_Float12;Float 12;3;0;Create;True;0;0;False;0;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;73;-2722.906,1015.304;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-2646.464,1536.702;Inherit;False;Constant;_speed1;speed1;3;0;Create;True;0;0;False;0;-0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;79;-2652.565,1632.414;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-2716.805,919.5922;Inherit;False;Constant;_Float11;Float 11;3;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;76;-2732.182,689.5747;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;82;-2709.694,1332.012;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-2726.081,593.8627;Inherit;False;Constant;_Float10;Float 10;3;0;Create;True;0;0;False;0;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-2541.843,-83.26569;Inherit;True;Constant;_Float2;Float 2;0;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;83;-2342.642,1163.355;Inherit;False;Constant;_Vector4;Vector 4;3;0;Create;True;0;0;False;0;2,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;78;-2310.6,1623.608;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;55;-2355.854,846.6483;Inherit;False;Constant;_Vector2;Vector 2;3;0;Create;True;0;0;False;0;5,5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;61;-2317.492,1478.463;Inherit;False;Constant;_Vector3;Vector 3;3;0;Create;True;0;0;False;0;100,100;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;75;-2390.217,680.7687;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;84;-2367.729,1323.206;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;72;-2380.941,1006.498;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;53;-2364.175,542.5305;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;40,40;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;56;-2131.166,837.9189;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-2144.197,533.8011;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;85;-2117.954,1154.626;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;25;-2353.843,-82.26569;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;-2097.516,1469.733;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;27;-2092.832,-113.2582;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.07;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;86;-1821.154,1117.963;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;51;-1847.4,497.1379;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;60;-1800.721,1433.07;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;54;-1834.368,801.2557;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;26;-2079.844,-364.2658;Inherit;False;Constant;_Vector1;Vector 1;0;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;28;-1724.629,-544.2199;Inherit;False;Constant;_Float3;Float 3;0;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-1554.229,1310.906;Inherit;False;Constant;_Float8;Float 8;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;63;-1589.184,1411.291;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;87;-1609.618,1096.184;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;57;-1622.832,779.4768;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;52;-1635.863,475.359;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-1828.844,-400.2656;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;65;-1557.173,1628.988;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;False;0;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-1601.413,1012.633;Inherit;False;Constant;_Float7;Float 7;3;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1598.918,689.1183;Inherit;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-1317.35,498.9122;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;31;-1526.995,-173.5081;Inherit;False;Property;_Linecolor;Line color;1;0;Create;True;0;0;False;0;0,0.9394503,1,0;0,0.9394503,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-1341.961,1411.887;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;30;-1537.108,-481.1598;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-1362.008,1108.414;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-1376.413,766.6327;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-1059.904,475.8983;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1193.878,-457.5119;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;125;-349.0109,-717.8831;Inherit;False;Constant;_Color1;Color 1;5;0;Create;True;0;0;False;0;0,1,0.9336774,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;114;-389.6694,-906.9166;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;-1;5228a04ef529d2641937cab585cc1a02;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;109;-1058.151,-594.1576;Inherit;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;123;-368.0545,-991.8259;Inherit;False;Property;_EMISSION;EMISSION;4;0;Create;True;0;0;False;0;1;1;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-545.9791,-123.3405;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-13.10633,-839.696;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;120;-119.1855,69.07965;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;112;-806.8746,-533.2255;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;118;-348.4281,-505.1612;Inherit;False;Property;_OPACITY;OPACITY;3;0;Create;True;0;0;False;0;0.7;0.7;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;111;-542.2498,-324.9985;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;3.719332,-355.8058;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;121;52.66453,-535.636;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;108;-515.8497,440.7469;Inherit;False;Constant;_Color0;Color 0;2;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;113;236.6902,-318.6832;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;105;418.8288,-246.6169;Float;False;True;-1;2;ASEMaterialInspector;0;4;Hologramme;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;True;2;False;-1;True;True;True;True;True;0;True;-9;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;0
WireConnection;78;2;80;0
WireConnection;78;1;79;0
WireConnection;75;2;77;0
WireConnection;75;1;76;0
WireConnection;84;2;81;0
WireConnection;84;1;82;0
WireConnection;72;2;74;0
WireConnection;72;1;73;0
WireConnection;56;0;55;0
WireConnection;56;1;72;0
WireConnection;50;0;53;0
WireConnection;50;1;75;0
WireConnection;85;0;83;0
WireConnection;85;1;84;0
WireConnection;25;0;24;0
WireConnection;62;0;61;0
WireConnection;62;1;78;0
WireConnection;27;1;25;0
WireConnection;86;0;85;2
WireConnection;51;0;50;2
WireConnection;60;0;62;2
WireConnection;54;0;56;2
WireConnection;63;0;60;0
WireConnection;87;0;86;0
WireConnection;57;0;54;0
WireConnection;52;0;51;0
WireConnection;29;0;26;0
WireConnection;29;1;27;0
WireConnection;88;0;52;0
WireConnection;88;1;89;0
WireConnection;66;0;63;0
WireConnection;66;1;65;0
WireConnection;30;0;29;0
WireConnection;30;1;28;0
WireConnection;92;0;87;0
WireConnection;92;1;93;0
WireConnection;90;0;57;0
WireConnection;90;1;91;0
WireConnection;59;0;88;0
WireConnection;59;1;90;0
WireConnection;59;2;92;0
WireConnection;59;3;66;0
WireConnection;32;0;31;0
WireConnection;32;1;30;0
WireConnection;67;0;32;0
WireConnection;67;1;59;0
WireConnection;124;0;123;0
WireConnection;124;1;114;0
WireConnection;124;2;125;0
WireConnection;120;0;67;0
WireConnection;112;0;109;0
WireConnection;110;0;112;0
WireConnection;110;1;111;0
WireConnection;110;2;120;0
WireConnection;121;0;124;0
WireConnection;121;3;118;0
WireConnection;113;0;121;0
WireConnection;113;1;110;0
WireConnection;105;0;113;0
ASEEND*/
//CHKSM=26C617D258FE2D9B25DD9553AF568BDE3792538E