// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Slime Rancher/Pixel Display"
{
	Properties
	{
		_PixelsX("Pixels X", Float) = 64
		_PixelsY("Pixels Y", Float) = 64
		_GlitchPixelsX("Glitch Pixels X", Float) = 8
		_GlitchPixelsY("Glitch Pixels Y", Float) = 8
		_MainTexture("Main Texture", 2D) = "white" {}
		_LCDPixels("LCD Pixels", 2D) = "white" {}
		_MinDistance("Min Distance", Float) = 0.25
		_MaxDistance("Max Distance", Float) = 5
		_FarBrightness("Far Brightness", Float) = 1.2
		_CloseBrightness("Close Brightness", Float) = 1
		_PulseSpeed("Pulse Speed", Float) = 1.5
		_DimSpeed("Dim Speed", Float) = 0.25
		_DimFreq("Dim Freq", Float) = 1
		_PulseFreq("Pulse Freq", Float) = 1
		_PulseLead("Pulse Lead", Float) = 0.1
		_DimWidth("Dim Width", Float) = 0.01
		_PulseWidth("Pulse Width", Float) = 0.06
		_PulsePower("Pulse Power", Float) = 3
		_DimPower("Dim Power", Float) = 2
		_DimStrength("Dim Strength", Float) = 0.8
		_EdgeGlowColour("Edge Glow Colour", Color) = (0.1773662,0.1588643,0.3207547,1)
		_WobbleStrength("Wobble Strength", Float) = 0.01
		_WobbleSpeed("Wobble Speed", Float) = 1
		_WobbleFreq("Wobble Freq", Float) = -1
		_Brightness("Brightness", Float) = 1.8
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _CloseBrightness;
		uniform float _FarBrightness;
		uniform float _MinDistance;
		uniform float _MaxDistance;
		uniform sampler2D _LCDPixels;
		uniform float _PixelsX;
		uniform float _PixelsY;
		uniform sampler2D _MainTexture;
		uniform float _GlitchPixelsX;
		uniform float _GlitchPixelsY;
		uniform float _PulseLead;
		uniform float _PulseFreq;
		uniform float _PulseSpeed;
		uniform float _PulseWidth;
		uniform float _PulsePower;
		uniform float _WobbleStrength;
		uniform float _WobbleFreq;
		uniform float _WobbleSpeed;
		uniform float _DimFreq;
		uniform float _DimSpeed;
		uniform float _DimWidth;
		uniform float _DimPower;
		uniform float _DimStrength;
		uniform float4 _EdgeGlowColour;
		uniform float _Brightness;

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float clampResult77 = clamp( distance( _WorldSpaceCameraPos , ase_worldPos ) , _MinDistance , _MaxDistance );
			float lerpResult82 = lerp( _CloseBrightness , _FarBrightness , (0.0 + (clampResult77 - _MinDistance) * (1.0 - 0.0) / (_MaxDistance - _MinDistance)));
			float2 appendResult5 = (float2(_PixelsX , _PixelsY));
			float4 tex2DNode18 = tex2D( _LCDPixels, ( appendResult5 * i.uv_texcoord ) );
			float2 appendResult68 = (float2(_GlitchPixelsX , _GlitchPixelsY));
			float2 temp_output_92_0 = ( ( floor( ( appendResult5 * i.uv_texcoord ) ) / appendResult5 ) + ( float2( 0.5,0.5 ) / appendResult5 ) );
			float2 break100 = temp_output_92_0;
			float mulTime42 = _Time.y * _PulseSpeed;
			float temp_output_56_0 = ( 1.0 - _PulseWidth );
			float clampResult53 = clamp( sin( ( ( _PulseLead * break100.x ) + ( _PulseFreq * break100.y ) + mulTime42 ) ) , temp_output_56_0 , 1.0 );
			float2 lerpResult69 = lerp( appendResult5 , appendResult68 , pow( (0.0 + (clampResult53 - temp_output_56_0) * (1.0 - 0.0) / (1.0 - temp_output_56_0)) , _PulsePower ));
			float2 break106 = floor( log2( lerpResult69 ) );
			float2 appendResult108 = (float2(pow( 2.0 , break106.x ) , pow( 2.0 , break106.y )));
			float mulTime185 = _Time.y * _WobbleSpeed;
			float2 appendResult190 = (float2(0.0 , ( _WobbleStrength * sin( ( ( _WobbleFreq * i.uv_texcoord.x ) + mulTime185 ) ) )));
			float4 tex2DNode14 = tex2D( _MainTexture, ( ( ( floor( ( i.uv_texcoord * appendResult108 ) ) / appendResult108 ) + ( float2( 0.5,0.5 ) / appendResult108 ) ) + appendResult190 ) );
			float mulTime165 = _Time.y * _DimSpeed;
			float temp_output_170_0 = ( 1.0 - _DimWidth );
			float clampResult171 = clamp( sin( ( ( _DimFreq * temp_output_92_0.y ) + mulTime165 ) ) , temp_output_170_0 , 1.0 );
			float3 clampResult147 = clamp( ( ( lerpResult82 * ( (tex2DNode18).rgb * (tex2DNode14).rgb * (1.0 + (pow( (0.0 + (clampResult171 - temp_output_170_0) * (1.0 - 0.0) / (1.0 - temp_output_170_0)) , _DimPower ) - 0.0) * (_DimStrength - 1.0) / (1.0 - 0.0)) ) ) + ( (1.0 + (pow( (0.0 + (clampResult171 - temp_output_170_0) * (1.0 - 0.0) / (1.0 - temp_output_170_0)) , _DimPower ) - 0.0) * (_DimStrength - 1.0) / (1.0 - 0.0)) * ( ( 1.414 * distance( i.uv_texcoord , float2( 0.5,0.5 ) ) ) * (_EdgeGlowColour).rgb ) ) ) , float3( 0,0,0 ) , float3( 1,1,1 ) );
			o.Emission = ( clampResult147 * _Brightness );
			o.Alpha = ( tex2DNode18.a * tex2DNode14.a );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

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
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
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
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
Version=15301
1930;29;1897;1004;4565.593;215.8929;2.908539;True;False
Node;AmplifyShaderEditor.RangedFloatNode;4;-5397.018,587.4554;Float;False;Property;_PixelsY;Pixels Y;1;0;Create;True;0;0;False;0;64;64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-5397.419,508.455;Float;False;Property;_PixelsX;Pixels X;0;0;Create;True;0;0;False;0;64;64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;5;-5179.786,569.2985;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-5271.289,683.8011;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-4905.789,479.6194;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;118;-4904.05,686.585;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FloorOpNode;89;-4752.099,481.1925;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;93;-4604.483,543.0508;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;91;-4761.792,651.3401;Float;False;2;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-4416.509,638.6484;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;100;-4169.824,643.4724;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;30;-4088.35,556.6024;Float;False;Property;_PulseFreq;Pulse Freq;13;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-4090.962,471.6176;Float;False;Property;_PulseLead;Pulse Lead;14;0;Create;True;0;0;False;0;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-4097.111,751.4347;Float;False;Property;_PulseSpeed;Pulse Speed;10;0;Create;True;0;0;False;0;1.5;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;42;-3889.812,742.7346;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-3861.551,638.7047;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-3862.962,539.6176;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-3490.863,927.4623;Float;False;Property;_PulseWidth;Pulse Width;16;0;Create;True;0;0;False;0;0.06;0.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-3642.84,692.5209;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;28;-3487.952,693.2115;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;56;-3278.363,921.865;Float;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;53;-3038.163,869.2662;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;59;-2798.362,1049.266;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;58;-3068.763,1081.767;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;98;-4920.816,411.3365;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-3068.212,639.1698;Float;False;Property;_GlitchPixelsY;Glitch Pixels Y;3;0;Create;True;0;0;False;0;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-3024.148,1288.09;Float;False;Property;_PulsePower;Pulse Power;17;0;Create;True;0;0;False;0;3;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-3066.743,558.7885;Float;False;Property;_GlitchPixelsX;Glitch Pixels X;2;0;Create;True;0;0;False;0;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;57;-3038.463,1113.365;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;87;-2745.231,395.5694;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;68;-2756.516,563.5247;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;101;-2744.85,1090.258;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;69;-2548.716,494.4254;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Log2OpNode;103;-2385.347,493.9838;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;197;-4307.997,885.1963;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FloorOpNode;84;-2257.921,494.6323;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;198;-4550.62,1007.871;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;129;-2153.415,622.9471;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;160;-4499.607,1214.664;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;163;-4401.134,1130.793;Float;False;Property;_DimFreq;Dim Freq;12;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-4405.895,1325.626;Float;False;Property;_DimSpeed;Dim Speed;11;0;Create;True;0;0;False;0;0.25;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;130;-2385.219,636.5472;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;106;-2352.395,697.0804;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;-4191.334,1209.896;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;165;-4219.596,1313.926;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;167;-3972.624,1263.712;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;184;-2690.612,2214.104;Float;False;Property;_WobbleSpeed;Wobble Speed;22;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;168;-3835.365,1498.096;Float;False;Property;_DimWidth;Dim Width;15;0;Create;True;0;0;False;0;0.01;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;107;-2023.594,780.8803;Float;False;2;0;FLOAT;2;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;181;-2600.257,2013.919;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;183;-2542.129,1926.952;Float;False;Property;_WobbleFreq;Wobble Freq;23;0;Create;True;0;0;False;0;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;104;-2025.594,678.8803;Float;False;2;0;FLOAT;2;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1879.326,371.7469;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;170;-3622.865,1492.498;Float;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;185;-2499.177,2217.788;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;108;-1816.145,703.7908;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinOpNode;169;-3832.454,1263.845;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;-2273.381,2054.576;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;186;-2097.9,2113.48;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-1446.497,581.342;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;171;-3382.665,1439.9;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;6;-1288.434,587.5813;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;172;-3142.864,1619.899;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;187;-1956.779,2112.252;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;110;-2135.748,323.9493;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;189;-1991.139,1988.309;Float;False;Property;_WobbleStrength;Wobble Strength;21;0;Create;True;0;0;False;0;0.01;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;-1729.756,2021.443;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;109;-1772.553,266.8557;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;10;-1315.991,760.3159;Float;False;2;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;7;-1135.801,637.2107;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;173;-3413.265,1652.4;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1444.932,453.8953;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-3368.65,1858.723;Float;False;Property;_DimPower;Dim Power;18;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;72;-1080.241,-379.4351;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-969.9528,732.265;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;190;-1525.298,1936.361;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;71;-1157.241,-520.4356;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode;174;-3382.965,1683.998;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;176;-3089.352,1660.891;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;19;-899.9738,114.5293;Float;True;Property;_LCDPixels;LCD Pixels;5;0;Create;True;0;0;False;0;40494fd7320a81549ad1ed0e0de96fbe;f8b39c64e4d503246a0d6362362a6eeb;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;15;-907.8629,512.8735;Float;True;Property;_MainTexture;Main Texture;4;0;Create;True;0;0;False;0;d641652bb9fb8c44faaf639602bee53f;ede5ef25ae80e35448ae003e463cc91d;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-775.2429,-267.435;Float;False;Property;_MaxDistance;Max Distance;7;0;Create;True;0;0;False;0;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;66;-910.4228,394.2137;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;132;-737.177,1155.302;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;178;-3031.287,1884.236;Float;False;Property;_DimStrength;Dim Strength;19;0;Create;True;0;0;False;0;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-774.2429,-351.435;Float;False;Property;_MinDistance;Min Distance;6;0;Create;True;0;0;False;0;0.25;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;73;-778.2429,-453.4354;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;191;-720.1982,875.3308;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;18;-483.5518,183.3319;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;134;-447.1129,1156.896;Float;False;2;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;77;-544.2401,-418.4353;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;177;-2542.287,1596.236;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;135;-539.1256,1280.996;Float;False;Property;_EdgeGlowColour;Edge Glow Colour;20;0;Create;True;0;0;False;0;0.1773662,0.1588643,0.3207547,1;0.1773662,0.1588643,0.3207547,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-556.8627,577.769;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;195;-298.3727,-291.8644;Float;False;Property;_FarBrightness;Far Brightness;8;0;Create;True;0;0;False;0;1.2;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-309.6335,-379.0712;Float;False;Property;_CloseBrightness;Close Brightness;9;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;138;-209.6727,1373.18;Float;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;20;-168.9517,185.2318;Float;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RelayNode;125;-438.2119,905.0278;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;80;-297.6678,-205.7391;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;16;-258.8626,577.769;Float;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;-251.3601,1151.302;Float;True;2;2;0;FLOAT;1.414;False;1;FLOAT;0.7072136;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;232.7476,393.232;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;82;-33.37252,-269.0131;Float;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;88.32761,1184.18;Float;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;405.0453,174.9504;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;305.2582,910.4633;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;141;645.1391,322.7639;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;194;793.8687,461.9217;Float;False;Property;_Brightness;Brightness;24;0;Create;True;0;0;False;0;1.8;1.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;147;825.4146,324.4249;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;193;1040.325,400.205;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;235.0474,525.2322;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1229.663,339.6929;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Slime Rancher/Pixel Display;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;88;0;5;0
WireConnection;88;1;23;0
WireConnection;118;0;5;0
WireConnection;89;0;88;0
WireConnection;93;0;89;0
WireConnection;93;1;5;0
WireConnection;91;1;118;0
WireConnection;92;0;93;0
WireConnection;92;1;91;0
WireConnection;100;0;92;0
WireConnection;42;0;40;0
WireConnection;29;0;30;0
WireConnection;29;1;100;1
WireConnection;145;0;146;0
WireConnection;145;1;100;0
WireConnection;27;0;145;0
WireConnection;27;1;29;0
WireConnection;27;2;42;0
WireConnection;28;0;27;0
WireConnection;56;1;54;0
WireConnection;53;0;28;0
WireConnection;53;1;56;0
WireConnection;59;0;53;0
WireConnection;58;0;59;0
WireConnection;98;0;5;0
WireConnection;57;0;58;0
WireConnection;57;1;56;0
WireConnection;87;0;98;0
WireConnection;68;0;62;0
WireConnection;68;1;63;0
WireConnection;101;0;57;0
WireConnection;101;1;102;0
WireConnection;69;0;87;0
WireConnection;69;1;68;0
WireConnection;69;2;101;0
WireConnection;103;0;69;0
WireConnection;197;0;92;0
WireConnection;84;0;103;0
WireConnection;198;0;197;0
WireConnection;129;0;84;0
WireConnection;160;0;198;0
WireConnection;130;0;129;0
WireConnection;106;0;130;0
WireConnection;164;0;163;0
WireConnection;164;1;160;1
WireConnection;165;0;162;0
WireConnection;167;0;164;0
WireConnection;167;1;165;0
WireConnection;107;1;106;1
WireConnection;104;1;106;0
WireConnection;170;1;168;0
WireConnection;185;0;184;0
WireConnection;108;0;104;0
WireConnection;108;1;107;0
WireConnection;169;0;167;0
WireConnection;182;0;183;0
WireConnection;182;1;181;1
WireConnection;186;0;182;0
WireConnection;186;1;185;0
WireConnection;70;0;1;0
WireConnection;70;1;108;0
WireConnection;171;0;169;0
WireConnection;171;1;170;0
WireConnection;6;0;70;0
WireConnection;172;0;171;0
WireConnection;187;0;186;0
WireConnection;110;0;87;0
WireConnection;188;0;189;0
WireConnection;188;1;187;0
WireConnection;109;0;110;0
WireConnection;10;1;108;0
WireConnection;7;0;6;0
WireConnection;7;1;108;0
WireConnection;173;0;172;0
WireConnection;2;0;109;0
WireConnection;2;1;1;0
WireConnection;13;0;7;0
WireConnection;13;1;10;0
WireConnection;190;1;188;0
WireConnection;174;0;173;0
WireConnection;174;1;170;0
WireConnection;176;0;174;0
WireConnection;176;1;175;0
WireConnection;66;0;2;0
WireConnection;73;0;71;0
WireConnection;73;1;72;0
WireConnection;191;0;13;0
WireConnection;191;1;190;0
WireConnection;18;0;19;0
WireConnection;18;1;66;0
WireConnection;134;0;132;0
WireConnection;77;0;73;0
WireConnection;77;1;74;0
WireConnection;77;2;75;0
WireConnection;177;0;176;0
WireConnection;177;4;178;0
WireConnection;14;0;15;0
WireConnection;14;1;191;0
WireConnection;138;0;135;0
WireConnection;20;0;18;0
WireConnection;125;0;177;0
WireConnection;80;0;77;0
WireConnection;80;1;74;0
WireConnection;80;2;75;0
WireConnection;16;0;14;0
WireConnection;136;1;134;0
WireConnection;21;0;20;0
WireConnection;21;1;16;0
WireConnection;21;2;125;0
WireConnection;82;0;81;0
WireConnection;82;1;195;0
WireConnection;82;2;80;0
WireConnection;139;0;136;0
WireConnection;139;1;138;0
WireConnection;83;0;82;0
WireConnection;83;1;21;0
WireConnection;180;0;125;0
WireConnection;180;1;139;0
WireConnection;141;0;83;0
WireConnection;141;1;180;0
WireConnection;147;0;141;0
WireConnection;193;0;147;0
WireConnection;193;1;194;0
WireConnection;22;0;18;4
WireConnection;22;1;14;4
WireConnection;0;2;193;0
WireConnection;0;9;22;0
ASEEND*/
//CHKSM=28CF69E3880299D4D94FDD02025EC19E93B39CD0