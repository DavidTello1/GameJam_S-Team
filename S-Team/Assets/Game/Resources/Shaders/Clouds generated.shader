Shader "Clouds Generated"
{
    Properties
    {
        Vector4_E424CB7C("Rotate Projection", Vector) = (1, 0, 0, 0)
        Vector1_F29DE894("Noise Scale", Float) = 10
        Vector1_ADB935E6("Noise Speed", Float) = 0.1
        Vector1_16964F0A("Noise Height", Float) = 1
        Vector4_65B2B9F5("Noise Remap", Vector) = (0, 1, -1, 1)
        Color_8066FEFA("Color Valley", Color) = (0, 0, 0, 0)
        Color_A96B191A("Color Peak", Color) = (1, 1, 1, 0)
        Vector1_B143DD0E("Noise Edge 1", Float) = 0
        Vector1_7DBFCEE0("Noise Edge 2", Float) = 1
        Vector1_23F8D690("Noise Power", Float) = 1
        Vector1_87E56D94("Base Scale", Float) = 5
        Vector1_A5060078("Base Speed", Float) = 0.2
        Vector1_91381CE2("Base Strength", Float) = 2
        Vector1_7E571236("Emission Strength", Float) = 2
        Vector1_C007421A("CUrvature Radius", Float) = 1
        Vector1_8D1762FD("Fresnel Power", Float) = 1
        Vector1_B3F40E86("Fresnel opacity", Float) = 1
        Vector1_BEEE60AF("Fade Depth", Float) = 100
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "Queue"="Transparent+0"
        }
        
        Pass
        {
            Name "Pass"
            Tags 
            { 
                // LightMode: <None>
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
        
            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma shader_feature _ _SAMPLE_GI
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS_UNLIT
            #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_E424CB7C;
            float Vector1_F29DE894;
            float Vector1_ADB935E6;
            float Vector1_16964F0A;
            float4 Vector4_65B2B9F5;
            float4 Color_8066FEFA;
            float4 Color_A96B191A;
            float Vector1_B143DD0E;
            float Vector1_7DBFCEE0;
            float Vector1_23F8D690;
            float Vector1_87E56D94;
            float Vector1_A5060078;
            float Vector1_91381CE2;
            float Vector1_7E571236;
            float Vector1_C007421A;
            float Vector1_8D1762FD;
            float Vector1_B3F40E86;
            float Vector1_BEEE60AF;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
            {
                Out = lerp(A, B, T);
            }
            
            void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
            {
                Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
            }
            
            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 WorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Vector1_B524B972_Out_0 = -1;
                float3 _Multiply_A0A2A540_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, (_Vector1_B524B972_Out_0.xxx), _Multiply_A0A2A540_Out_2);
                float _Distance_D439746_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_D439746_Out_2);
                float _Property_A34907AB_Out_0 = Vector1_C007421A;
                float _Divide_F62088AB_Out_2;
                Unity_Divide_float(_Distance_D439746_Out_2, _Property_A34907AB_Out_0, _Divide_F62088AB_Out_2);
                float _Power_65E90A80_Out_2;
                Unity_Power_float(_Divide_F62088AB_Out_2, 3, _Power_65E90A80_Out_2);
                float3 _Multiply_88A97C10_Out_2;
                Unity_Multiply_float(_Multiply_A0A2A540_Out_2, (_Power_65E90A80_Out_2.xxx), _Multiply_88A97C10_Out_2);
                float _Property_AE65DA6E_Out_0 = Vector1_16964F0A;
                float _Property_DB9B9FB1_Out_0 = Vector1_B143DD0E;
                float _Property_B545C64A_Out_0 = Vector1_7DBFCEE0;
                float4 _Property_CDA1550D_Out_0 = Vector4_E424CB7C;
                float _Split_64E8BEC8_R_1 = _Property_CDA1550D_Out_0[0];
                float _Split_64E8BEC8_G_2 = _Property_CDA1550D_Out_0[1];
                float _Split_64E8BEC8_B_3 = _Property_CDA1550D_Out_0[2];
                float _Split_64E8BEC8_A_4 = _Property_CDA1550D_Out_0[3];
                float3 _RotateAboutAxis_F51983B5_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_CDA1550D_Out_0.xyz), _Split_64E8BEC8_A_4, _RotateAboutAxis_F51983B5_Out_3);
                float _Property_C8CC5D2F_Out_0 = Vector1_ADB935E6;
                float _Multiply_79ABC317_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_C8CC5D2F_Out_0, _Multiply_79ABC317_Out_2);
                float2 _TilingAndOffset_C90CD372_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_F51983B5_Out_3.xy), float2 (1, 1), (_Multiply_79ABC317_Out_2.xx), _TilingAndOffset_C90CD372_Out_3);
                float _Property_ED60AA82_Out_0 = Vector1_F29DE894;
                float _GradientNoise_8649F034_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_C90CD372_Out_3, _Property_ED60AA82_Out_0, _GradientNoise_8649F034_Out_2);
                float2 _TilingAndOffset_CD4127F2_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_F51983B5_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_CD4127F2_Out_3);
                float _GradientNoise_9AADD7A3_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_CD4127F2_Out_3, _Property_ED60AA82_Out_0, _GradientNoise_9AADD7A3_Out_2);
                float _Add_E50819FC_Out_2;
                Unity_Add_float(_GradientNoise_8649F034_Out_2, _GradientNoise_9AADD7A3_Out_2, _Add_E50819FC_Out_2);
                float _Divide_84F0199C_Out_2;
                Unity_Divide_float(_Add_E50819FC_Out_2, 2, _Divide_84F0199C_Out_2);
                float _Saturate_80596430_Out_1;
                Unity_Saturate_float(_Divide_84F0199C_Out_2, _Saturate_80596430_Out_1);
                float _Property_6FC65844_Out_0 = Vector1_23F8D690;
                float _Power_6952B4F0_Out_2;
                Unity_Power_float(_Saturate_80596430_Out_1, _Property_6FC65844_Out_0, _Power_6952B4F0_Out_2);
                float4 _Property_F3E13C5_Out_0 = Vector4_65B2B9F5;
                float _Split_DF1B2A9F_R_1 = _Property_F3E13C5_Out_0[0];
                float _Split_DF1B2A9F_G_2 = _Property_F3E13C5_Out_0[1];
                float _Split_DF1B2A9F_B_3 = _Property_F3E13C5_Out_0[2];
                float _Split_DF1B2A9F_A_4 = _Property_F3E13C5_Out_0[3];
                float4 _Combine_C024E175_RGBA_4;
                float3 _Combine_C024E175_RGB_5;
                float2 _Combine_C024E175_RG_6;
                Unity_Combine_float(_Split_DF1B2A9F_R_1, _Split_DF1B2A9F_G_2, 0, 0, _Combine_C024E175_RGBA_4, _Combine_C024E175_RGB_5, _Combine_C024E175_RG_6);
                float4 _Combine_D951EE75_RGBA_4;
                float3 _Combine_D951EE75_RGB_5;
                float2 _Combine_D951EE75_RG_6;
                Unity_Combine_float(_Split_DF1B2A9F_B_3, _Split_DF1B2A9F_A_4, 0, 0, _Combine_D951EE75_RGBA_4, _Combine_D951EE75_RGB_5, _Combine_D951EE75_RG_6);
                float _Remap_F144504F_Out_3;
                Unity_Remap_float(_Power_6952B4F0_Out_2, _Combine_C024E175_RG_6, _Combine_D951EE75_RG_6, _Remap_F144504F_Out_3);
                float _Absolute_EFB759F0_Out_1;
                Unity_Absolute_float(_Remap_F144504F_Out_3, _Absolute_EFB759F0_Out_1);
                float _Smoothstep_E4CAAC7_Out_3;
                Unity_Smoothstep_float(_Property_DB9B9FB1_Out_0, _Property_B545C64A_Out_0, _Absolute_EFB759F0_Out_1, _Smoothstep_E4CAAC7_Out_3);
                float _Property_AACC4CF1_Out_0 = Vector1_A5060078;
                float _Multiply_3CA1059A_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_AACC4CF1_Out_0, _Multiply_3CA1059A_Out_2);
                float2 _TilingAndOffset_7C3A3642_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_F51983B5_Out_3.xy), float2 (1, 1), (_Multiply_3CA1059A_Out_2.xx), _TilingAndOffset_7C3A3642_Out_3);
                float _Property_FBDDB569_Out_0 = Vector1_87E56D94;
                float _GradientNoise_981171A6_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_7C3A3642_Out_3, _Property_FBDDB569_Out_0, _GradientNoise_981171A6_Out_2);
                float _Property_C43FBF59_Out_0 = Vector1_91381CE2;
                float _Multiply_3D766C6C_Out_2;
                Unity_Multiply_float(_GradientNoise_981171A6_Out_2, _Property_C43FBF59_Out_0, _Multiply_3D766C6C_Out_2);
                float _Add_77D7ABA7_Out_2;
                Unity_Add_float(_Smoothstep_E4CAAC7_Out_3, _Multiply_3D766C6C_Out_2, _Add_77D7ABA7_Out_2);
                float _Add_815A81E9_Out_2;
                Unity_Add_float(1, _Property_C43FBF59_Out_0, _Add_815A81E9_Out_2);
                float _Divide_4F5D0EE7_Out_2;
                Unity_Divide_float(_Add_77D7ABA7_Out_2, _Add_815A81E9_Out_2, _Divide_4F5D0EE7_Out_2);
                float3 _Multiply_FFAF1274_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_4F5D0EE7_Out_2.xxx), _Multiply_FFAF1274_Out_2);
                float3 _Multiply_3BA51423_Out_2;
                Unity_Multiply_float((_Property_AE65DA6E_Out_0.xxx), _Multiply_FFAF1274_Out_2, _Multiply_3BA51423_Out_2);
                float3 _Add_B5E099_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_3BA51423_Out_2, _Add_B5E099_Out_2);
                float3 _Add_398E3340_Out_2;
                Unity_Add_float3(_Multiply_88A97C10_Out_2, _Add_B5E099_Out_2, _Add_398E3340_Out_2);
                description.VertexPosition = _Add_398E3340_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpaceNormal;
                float3 WorldSpaceViewDirection;
                float3 WorldSpacePosition;
                float4 ScreenPosition;
                float3 TimeParameters;
            };
            
            struct SurfaceDescription
            {
                float3 Color;
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _Property_C28DC4DC_Out_0 = Color_8066FEFA;
                float4 _Property_6EE3DA72_Out_0 = Color_A96B191A;
                float _Property_DB9B9FB1_Out_0 = Vector1_B143DD0E;
                float _Property_B545C64A_Out_0 = Vector1_7DBFCEE0;
                float4 _Property_CDA1550D_Out_0 = Vector4_E424CB7C;
                float _Split_64E8BEC8_R_1 = _Property_CDA1550D_Out_0[0];
                float _Split_64E8BEC8_G_2 = _Property_CDA1550D_Out_0[1];
                float _Split_64E8BEC8_B_3 = _Property_CDA1550D_Out_0[2];
                float _Split_64E8BEC8_A_4 = _Property_CDA1550D_Out_0[3];
                float3 _RotateAboutAxis_F51983B5_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_CDA1550D_Out_0.xyz), _Split_64E8BEC8_A_4, _RotateAboutAxis_F51983B5_Out_3);
                float _Property_C8CC5D2F_Out_0 = Vector1_ADB935E6;
                float _Multiply_79ABC317_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_C8CC5D2F_Out_0, _Multiply_79ABC317_Out_2);
                float2 _TilingAndOffset_C90CD372_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_F51983B5_Out_3.xy), float2 (1, 1), (_Multiply_79ABC317_Out_2.xx), _TilingAndOffset_C90CD372_Out_3);
                float _Property_ED60AA82_Out_0 = Vector1_F29DE894;
                float _GradientNoise_8649F034_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_C90CD372_Out_3, _Property_ED60AA82_Out_0, _GradientNoise_8649F034_Out_2);
                float2 _TilingAndOffset_CD4127F2_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_F51983B5_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_CD4127F2_Out_3);
                float _GradientNoise_9AADD7A3_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_CD4127F2_Out_3, _Property_ED60AA82_Out_0, _GradientNoise_9AADD7A3_Out_2);
                float _Add_E50819FC_Out_2;
                Unity_Add_float(_GradientNoise_8649F034_Out_2, _GradientNoise_9AADD7A3_Out_2, _Add_E50819FC_Out_2);
                float _Divide_84F0199C_Out_2;
                Unity_Divide_float(_Add_E50819FC_Out_2, 2, _Divide_84F0199C_Out_2);
                float _Saturate_80596430_Out_1;
                Unity_Saturate_float(_Divide_84F0199C_Out_2, _Saturate_80596430_Out_1);
                float _Property_6FC65844_Out_0 = Vector1_23F8D690;
                float _Power_6952B4F0_Out_2;
                Unity_Power_float(_Saturate_80596430_Out_1, _Property_6FC65844_Out_0, _Power_6952B4F0_Out_2);
                float4 _Property_F3E13C5_Out_0 = Vector4_65B2B9F5;
                float _Split_DF1B2A9F_R_1 = _Property_F3E13C5_Out_0[0];
                float _Split_DF1B2A9F_G_2 = _Property_F3E13C5_Out_0[1];
                float _Split_DF1B2A9F_B_3 = _Property_F3E13C5_Out_0[2];
                float _Split_DF1B2A9F_A_4 = _Property_F3E13C5_Out_0[3];
                float4 _Combine_C024E175_RGBA_4;
                float3 _Combine_C024E175_RGB_5;
                float2 _Combine_C024E175_RG_6;
                Unity_Combine_float(_Split_DF1B2A9F_R_1, _Split_DF1B2A9F_G_2, 0, 0, _Combine_C024E175_RGBA_4, _Combine_C024E175_RGB_5, _Combine_C024E175_RG_6);
                float4 _Combine_D951EE75_RGBA_4;
                float3 _Combine_D951EE75_RGB_5;
                float2 _Combine_D951EE75_RG_6;
                Unity_Combine_float(_Split_DF1B2A9F_B_3, _Split_DF1B2A9F_A_4, 0, 0, _Combine_D951EE75_RGBA_4, _Combine_D951EE75_RGB_5, _Combine_D951EE75_RG_6);
                float _Remap_F144504F_Out_3;
                Unity_Remap_float(_Power_6952B4F0_Out_2, _Combine_C024E175_RG_6, _Combine_D951EE75_RG_6, _Remap_F144504F_Out_3);
                float _Absolute_EFB759F0_Out_1;
                Unity_Absolute_float(_Remap_F144504F_Out_3, _Absolute_EFB759F0_Out_1);
                float _Smoothstep_E4CAAC7_Out_3;
                Unity_Smoothstep_float(_Property_DB9B9FB1_Out_0, _Property_B545C64A_Out_0, _Absolute_EFB759F0_Out_1, _Smoothstep_E4CAAC7_Out_3);
                float _Property_AACC4CF1_Out_0 = Vector1_A5060078;
                float _Multiply_3CA1059A_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_AACC4CF1_Out_0, _Multiply_3CA1059A_Out_2);
                float2 _TilingAndOffset_7C3A3642_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_F51983B5_Out_3.xy), float2 (1, 1), (_Multiply_3CA1059A_Out_2.xx), _TilingAndOffset_7C3A3642_Out_3);
                float _Property_FBDDB569_Out_0 = Vector1_87E56D94;
                float _GradientNoise_981171A6_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_7C3A3642_Out_3, _Property_FBDDB569_Out_0, _GradientNoise_981171A6_Out_2);
                float _Property_C43FBF59_Out_0 = Vector1_91381CE2;
                float _Multiply_3D766C6C_Out_2;
                Unity_Multiply_float(_GradientNoise_981171A6_Out_2, _Property_C43FBF59_Out_0, _Multiply_3D766C6C_Out_2);
                float _Add_77D7ABA7_Out_2;
                Unity_Add_float(_Smoothstep_E4CAAC7_Out_3, _Multiply_3D766C6C_Out_2, _Add_77D7ABA7_Out_2);
                float _Add_815A81E9_Out_2;
                Unity_Add_float(1, _Property_C43FBF59_Out_0, _Add_815A81E9_Out_2);
                float _Divide_4F5D0EE7_Out_2;
                Unity_Divide_float(_Add_77D7ABA7_Out_2, _Add_815A81E9_Out_2, _Divide_4F5D0EE7_Out_2);
                float4 _Lerp_F45CFD77_Out_3;
                Unity_Lerp_float4(_Property_C28DC4DC_Out_0, _Property_6EE3DA72_Out_0, (_Divide_4F5D0EE7_Out_2.xxxx), _Lerp_F45CFD77_Out_3);
                float _Property_CD99C011_Out_0 = Vector1_8D1762FD;
                float _FresnelEffect_BFE89738_Out_3;
                Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_CD99C011_Out_0, _FresnelEffect_BFE89738_Out_3);
                float _Multiply_3EE7F1F4_Out_2;
                Unity_Multiply_float(_Divide_4F5D0EE7_Out_2, _FresnelEffect_BFE89738_Out_3, _Multiply_3EE7F1F4_Out_2);
                float _Property_C38B3242_Out_0 = Vector1_B3F40E86;
                float _Multiply_3FF4A70E_Out_2;
                Unity_Multiply_float(_Multiply_3EE7F1F4_Out_2, _Property_C38B3242_Out_0, _Multiply_3FF4A70E_Out_2);
                float4 _Add_F248C393_Out_2;
                Unity_Add_float4(_Lerp_F45CFD77_Out_3, (_Multiply_3FF4A70E_Out_2.xxxx), _Add_F248C393_Out_2);
                float _Property_B67F59F8_Out_0 = Vector1_7E571236;
                float4 _Multiply_FB1F2D35_Out_2;
                Unity_Multiply_float(_Add_F248C393_Out_2, (_Property_B67F59F8_Out_0.xxxx), _Multiply_FB1F2D35_Out_2);
                float _SceneDepth_13177C16_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_13177C16_Out_1);
                float4 _ScreenPosition_B0D02E3D_Out_0 = IN.ScreenPosition;
                float _Split_A61C2887_R_1 = _ScreenPosition_B0D02E3D_Out_0[0];
                float _Split_A61C2887_G_2 = _ScreenPosition_B0D02E3D_Out_0[1];
                float _Split_A61C2887_B_3 = _ScreenPosition_B0D02E3D_Out_0[2];
                float _Split_A61C2887_A_4 = _ScreenPosition_B0D02E3D_Out_0[3];
                float _Subtract_592D5B7_Out_2;
                Unity_Subtract_float(_Split_A61C2887_A_4, 1, _Subtract_592D5B7_Out_2);
                float _Subtract_2F543E42_Out_2;
                Unity_Subtract_float(_SceneDepth_13177C16_Out_1, _Subtract_592D5B7_Out_2, _Subtract_2F543E42_Out_2);
                float _Property_D58C37C7_Out_0 = Vector1_BEEE60AF;
                float _Divide_A1D0D2B8_Out_2;
                Unity_Divide_float(_Subtract_2F543E42_Out_2, _Property_D58C37C7_Out_0, _Divide_A1D0D2B8_Out_2);
                float _Saturate_24C694F6_Out_1;
                Unity_Saturate_float(_Divide_A1D0D2B8_Out_2, _Saturate_24C694F6_Out_1);
                surface.Color = (_Multiply_FB1F2D35_Out_2.xyz);
                surface.Alpha = _Saturate_24C694F6_Out_1;
                surface.AlphaClipThreshold = 0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                float3 normalWS;
                float3 viewDirectionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                float3 interp01 : TEXCOORD1;
                float3 interp02 : TEXCOORD2;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyz = input.viewDirectionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.viewDirectionWS = input.interp02.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            	float3 unnormalizedNormalWS = input.normalWS;
                const float renormFactor = 1.0 / length(unnormalizedNormalWS);
            
            
                output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
            
            
                output.WorldSpaceViewDirection =     input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
                output.WorldSpacePosition =          input.positionWS;
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
                output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "ShadowCaster"
            Tags 
            { 
                "LightMode" = "ShadowCaster"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS_SHADOWCASTER
            #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_E424CB7C;
            float Vector1_F29DE894;
            float Vector1_ADB935E6;
            float Vector1_16964F0A;
            float4 Vector4_65B2B9F5;
            float4 Color_8066FEFA;
            float4 Color_A96B191A;
            float Vector1_B143DD0E;
            float Vector1_7DBFCEE0;
            float Vector1_23F8D690;
            float Vector1_87E56D94;
            float Vector1_A5060078;
            float Vector1_91381CE2;
            float Vector1_7E571236;
            float Vector1_C007421A;
            float Vector1_8D1762FD;
            float Vector1_B3F40E86;
            float Vector1_BEEE60AF;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 WorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Vector1_B524B972_Out_0 = -1;
                float3 _Multiply_A0A2A540_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, (_Vector1_B524B972_Out_0.xxx), _Multiply_A0A2A540_Out_2);
                float _Distance_D439746_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_D439746_Out_2);
                float _Property_A34907AB_Out_0 = Vector1_C007421A;
                float _Divide_F62088AB_Out_2;
                Unity_Divide_float(_Distance_D439746_Out_2, _Property_A34907AB_Out_0, _Divide_F62088AB_Out_2);
                float _Power_65E90A80_Out_2;
                Unity_Power_float(_Divide_F62088AB_Out_2, 3, _Power_65E90A80_Out_2);
                float3 _Multiply_88A97C10_Out_2;
                Unity_Multiply_float(_Multiply_A0A2A540_Out_2, (_Power_65E90A80_Out_2.xxx), _Multiply_88A97C10_Out_2);
                float _Property_AE65DA6E_Out_0 = Vector1_16964F0A;
                float _Property_DB9B9FB1_Out_0 = Vector1_B143DD0E;
                float _Property_B545C64A_Out_0 = Vector1_7DBFCEE0;
                float4 _Property_CDA1550D_Out_0 = Vector4_E424CB7C;
                float _Split_64E8BEC8_R_1 = _Property_CDA1550D_Out_0[0];
                float _Split_64E8BEC8_G_2 = _Property_CDA1550D_Out_0[1];
                float _Split_64E8BEC8_B_3 = _Property_CDA1550D_Out_0[2];
                float _Split_64E8BEC8_A_4 = _Property_CDA1550D_Out_0[3];
                float3 _RotateAboutAxis_F51983B5_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_CDA1550D_Out_0.xyz), _Split_64E8BEC8_A_4, _RotateAboutAxis_F51983B5_Out_3);
                float _Property_C8CC5D2F_Out_0 = Vector1_ADB935E6;
                float _Multiply_79ABC317_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_C8CC5D2F_Out_0, _Multiply_79ABC317_Out_2);
                float2 _TilingAndOffset_C90CD372_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_F51983B5_Out_3.xy), float2 (1, 1), (_Multiply_79ABC317_Out_2.xx), _TilingAndOffset_C90CD372_Out_3);
                float _Property_ED60AA82_Out_0 = Vector1_F29DE894;
                float _GradientNoise_8649F034_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_C90CD372_Out_3, _Property_ED60AA82_Out_0, _GradientNoise_8649F034_Out_2);
                float2 _TilingAndOffset_CD4127F2_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_F51983B5_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_CD4127F2_Out_3);
                float _GradientNoise_9AADD7A3_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_CD4127F2_Out_3, _Property_ED60AA82_Out_0, _GradientNoise_9AADD7A3_Out_2);
                float _Add_E50819FC_Out_2;
                Unity_Add_float(_GradientNoise_8649F034_Out_2, _GradientNoise_9AADD7A3_Out_2, _Add_E50819FC_Out_2);
                float _Divide_84F0199C_Out_2;
                Unity_Divide_float(_Add_E50819FC_Out_2, 2, _Divide_84F0199C_Out_2);
                float _Saturate_80596430_Out_1;
                Unity_Saturate_float(_Divide_84F0199C_Out_2, _Saturate_80596430_Out_1);
                float _Property_6FC65844_Out_0 = Vector1_23F8D690;
                float _Power_6952B4F0_Out_2;
                Unity_Power_float(_Saturate_80596430_Out_1, _Property_6FC65844_Out_0, _Power_6952B4F0_Out_2);
                float4 _Property_F3E13C5_Out_0 = Vector4_65B2B9F5;
                float _Split_DF1B2A9F_R_1 = _Property_F3E13C5_Out_0[0];
                float _Split_DF1B2A9F_G_2 = _Property_F3E13C5_Out_0[1];
                float _Split_DF1B2A9F_B_3 = _Property_F3E13C5_Out_0[2];
                float _Split_DF1B2A9F_A_4 = _Property_F3E13C5_Out_0[3];
                float4 _Combine_C024E175_RGBA_4;
                float3 _Combine_C024E175_RGB_5;
                float2 _Combine_C024E175_RG_6;
                Unity_Combine_float(_Split_DF1B2A9F_R_1, _Split_DF1B2A9F_G_2, 0, 0, _Combine_C024E175_RGBA_4, _Combine_C024E175_RGB_5, _Combine_C024E175_RG_6);
                float4 _Combine_D951EE75_RGBA_4;
                float3 _Combine_D951EE75_RGB_5;
                float2 _Combine_D951EE75_RG_6;
                Unity_Combine_float(_Split_DF1B2A9F_B_3, _Split_DF1B2A9F_A_4, 0, 0, _Combine_D951EE75_RGBA_4, _Combine_D951EE75_RGB_5, _Combine_D951EE75_RG_6);
                float _Remap_F144504F_Out_3;
                Unity_Remap_float(_Power_6952B4F0_Out_2, _Combine_C024E175_RG_6, _Combine_D951EE75_RG_6, _Remap_F144504F_Out_3);
                float _Absolute_EFB759F0_Out_1;
                Unity_Absolute_float(_Remap_F144504F_Out_3, _Absolute_EFB759F0_Out_1);
                float _Smoothstep_E4CAAC7_Out_3;
                Unity_Smoothstep_float(_Property_DB9B9FB1_Out_0, _Property_B545C64A_Out_0, _Absolute_EFB759F0_Out_1, _Smoothstep_E4CAAC7_Out_3);
                float _Property_AACC4CF1_Out_0 = Vector1_A5060078;
                float _Multiply_3CA1059A_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_AACC4CF1_Out_0, _Multiply_3CA1059A_Out_2);
                float2 _TilingAndOffset_7C3A3642_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_F51983B5_Out_3.xy), float2 (1, 1), (_Multiply_3CA1059A_Out_2.xx), _TilingAndOffset_7C3A3642_Out_3);
                float _Property_FBDDB569_Out_0 = Vector1_87E56D94;
                float _GradientNoise_981171A6_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_7C3A3642_Out_3, _Property_FBDDB569_Out_0, _GradientNoise_981171A6_Out_2);
                float _Property_C43FBF59_Out_0 = Vector1_91381CE2;
                float _Multiply_3D766C6C_Out_2;
                Unity_Multiply_float(_GradientNoise_981171A6_Out_2, _Property_C43FBF59_Out_0, _Multiply_3D766C6C_Out_2);
                float _Add_77D7ABA7_Out_2;
                Unity_Add_float(_Smoothstep_E4CAAC7_Out_3, _Multiply_3D766C6C_Out_2, _Add_77D7ABA7_Out_2);
                float _Add_815A81E9_Out_2;
                Unity_Add_float(1, _Property_C43FBF59_Out_0, _Add_815A81E9_Out_2);
                float _Divide_4F5D0EE7_Out_2;
                Unity_Divide_float(_Add_77D7ABA7_Out_2, _Add_815A81E9_Out_2, _Divide_4F5D0EE7_Out_2);
                float3 _Multiply_FFAF1274_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_4F5D0EE7_Out_2.xxx), _Multiply_FFAF1274_Out_2);
                float3 _Multiply_3BA51423_Out_2;
                Unity_Multiply_float((_Property_AE65DA6E_Out_0.xxx), _Multiply_FFAF1274_Out_2, _Multiply_3BA51423_Out_2);
                float3 _Add_B5E099_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_3BA51423_Out_2, _Add_B5E099_Out_2);
                float3 _Add_398E3340_Out_2;
                Unity_Add_float3(_Multiply_88A97C10_Out_2, _Add_B5E099_Out_2, _Add_398E3340_Out_2);
                description.VertexPosition = _Add_398E3340_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpacePosition;
                float4 ScreenPosition;
            };
            
            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float _SceneDepth_13177C16_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_13177C16_Out_1);
                float4 _ScreenPosition_B0D02E3D_Out_0 = IN.ScreenPosition;
                float _Split_A61C2887_R_1 = _ScreenPosition_B0D02E3D_Out_0[0];
                float _Split_A61C2887_G_2 = _ScreenPosition_B0D02E3D_Out_0[1];
                float _Split_A61C2887_B_3 = _ScreenPosition_B0D02E3D_Out_0[2];
                float _Split_A61C2887_A_4 = _ScreenPosition_B0D02E3D_Out_0[3];
                float _Subtract_592D5B7_Out_2;
                Unity_Subtract_float(_Split_A61C2887_A_4, 1, _Subtract_592D5B7_Out_2);
                float _Subtract_2F543E42_Out_2;
                Unity_Subtract_float(_SceneDepth_13177C16_Out_1, _Subtract_592D5B7_Out_2, _Subtract_2F543E42_Out_2);
                float _Property_D58C37C7_Out_0 = Vector1_BEEE60AF;
                float _Divide_A1D0D2B8_Out_2;
                Unity_Divide_float(_Subtract_2F543E42_Out_2, _Property_D58C37C7_Out_0, _Divide_A1D0D2B8_Out_2);
                float _Saturate_24C694F6_Out_1;
                Unity_Saturate_float(_Divide_A1D0D2B8_Out_2, _Saturate_24C694F6_Out_1);
                surface.Alpha = _Saturate_24C694F6_Out_1;
                surface.AlphaClipThreshold = 0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            
            
            
            
                output.WorldSpacePosition =          input.positionWS;
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "DepthOnly"
            Tags 
            { 
                "LightMode" = "DepthOnly"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite On
            ColorMask 0
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS_DEPTHONLY
            #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_E424CB7C;
            float Vector1_F29DE894;
            float Vector1_ADB935E6;
            float Vector1_16964F0A;
            float4 Vector4_65B2B9F5;
            float4 Color_8066FEFA;
            float4 Color_A96B191A;
            float Vector1_B143DD0E;
            float Vector1_7DBFCEE0;
            float Vector1_23F8D690;
            float Vector1_87E56D94;
            float Vector1_A5060078;
            float Vector1_91381CE2;
            float Vector1_7E571236;
            float Vector1_C007421A;
            float Vector1_8D1762FD;
            float Vector1_B3F40E86;
            float Vector1_BEEE60AF;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 WorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Vector1_B524B972_Out_0 = -1;
                float3 _Multiply_A0A2A540_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, (_Vector1_B524B972_Out_0.xxx), _Multiply_A0A2A540_Out_2);
                float _Distance_D439746_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_D439746_Out_2);
                float _Property_A34907AB_Out_0 = Vector1_C007421A;
                float _Divide_F62088AB_Out_2;
                Unity_Divide_float(_Distance_D439746_Out_2, _Property_A34907AB_Out_0, _Divide_F62088AB_Out_2);
                float _Power_65E90A80_Out_2;
                Unity_Power_float(_Divide_F62088AB_Out_2, 3, _Power_65E90A80_Out_2);
                float3 _Multiply_88A97C10_Out_2;
                Unity_Multiply_float(_Multiply_A0A2A540_Out_2, (_Power_65E90A80_Out_2.xxx), _Multiply_88A97C10_Out_2);
                float _Property_AE65DA6E_Out_0 = Vector1_16964F0A;
                float _Property_DB9B9FB1_Out_0 = Vector1_B143DD0E;
                float _Property_B545C64A_Out_0 = Vector1_7DBFCEE0;
                float4 _Property_CDA1550D_Out_0 = Vector4_E424CB7C;
                float _Split_64E8BEC8_R_1 = _Property_CDA1550D_Out_0[0];
                float _Split_64E8BEC8_G_2 = _Property_CDA1550D_Out_0[1];
                float _Split_64E8BEC8_B_3 = _Property_CDA1550D_Out_0[2];
                float _Split_64E8BEC8_A_4 = _Property_CDA1550D_Out_0[3];
                float3 _RotateAboutAxis_F51983B5_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_CDA1550D_Out_0.xyz), _Split_64E8BEC8_A_4, _RotateAboutAxis_F51983B5_Out_3);
                float _Property_C8CC5D2F_Out_0 = Vector1_ADB935E6;
                float _Multiply_79ABC317_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_C8CC5D2F_Out_0, _Multiply_79ABC317_Out_2);
                float2 _TilingAndOffset_C90CD372_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_F51983B5_Out_3.xy), float2 (1, 1), (_Multiply_79ABC317_Out_2.xx), _TilingAndOffset_C90CD372_Out_3);
                float _Property_ED60AA82_Out_0 = Vector1_F29DE894;
                float _GradientNoise_8649F034_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_C90CD372_Out_3, _Property_ED60AA82_Out_0, _GradientNoise_8649F034_Out_2);
                float2 _TilingAndOffset_CD4127F2_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_F51983B5_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_CD4127F2_Out_3);
                float _GradientNoise_9AADD7A3_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_CD4127F2_Out_3, _Property_ED60AA82_Out_0, _GradientNoise_9AADD7A3_Out_2);
                float _Add_E50819FC_Out_2;
                Unity_Add_float(_GradientNoise_8649F034_Out_2, _GradientNoise_9AADD7A3_Out_2, _Add_E50819FC_Out_2);
                float _Divide_84F0199C_Out_2;
                Unity_Divide_float(_Add_E50819FC_Out_2, 2, _Divide_84F0199C_Out_2);
                float _Saturate_80596430_Out_1;
                Unity_Saturate_float(_Divide_84F0199C_Out_2, _Saturate_80596430_Out_1);
                float _Property_6FC65844_Out_0 = Vector1_23F8D690;
                float _Power_6952B4F0_Out_2;
                Unity_Power_float(_Saturate_80596430_Out_1, _Property_6FC65844_Out_0, _Power_6952B4F0_Out_2);
                float4 _Property_F3E13C5_Out_0 = Vector4_65B2B9F5;
                float _Split_DF1B2A9F_R_1 = _Property_F3E13C5_Out_0[0];
                float _Split_DF1B2A9F_G_2 = _Property_F3E13C5_Out_0[1];
                float _Split_DF1B2A9F_B_3 = _Property_F3E13C5_Out_0[2];
                float _Split_DF1B2A9F_A_4 = _Property_F3E13C5_Out_0[3];
                float4 _Combine_C024E175_RGBA_4;
                float3 _Combine_C024E175_RGB_5;
                float2 _Combine_C024E175_RG_6;
                Unity_Combine_float(_Split_DF1B2A9F_R_1, _Split_DF1B2A9F_G_2, 0, 0, _Combine_C024E175_RGBA_4, _Combine_C024E175_RGB_5, _Combine_C024E175_RG_6);
                float4 _Combine_D951EE75_RGBA_4;
                float3 _Combine_D951EE75_RGB_5;
                float2 _Combine_D951EE75_RG_6;
                Unity_Combine_float(_Split_DF1B2A9F_B_3, _Split_DF1B2A9F_A_4, 0, 0, _Combine_D951EE75_RGBA_4, _Combine_D951EE75_RGB_5, _Combine_D951EE75_RG_6);
                float _Remap_F144504F_Out_3;
                Unity_Remap_float(_Power_6952B4F0_Out_2, _Combine_C024E175_RG_6, _Combine_D951EE75_RG_6, _Remap_F144504F_Out_3);
                float _Absolute_EFB759F0_Out_1;
                Unity_Absolute_float(_Remap_F144504F_Out_3, _Absolute_EFB759F0_Out_1);
                float _Smoothstep_E4CAAC7_Out_3;
                Unity_Smoothstep_float(_Property_DB9B9FB1_Out_0, _Property_B545C64A_Out_0, _Absolute_EFB759F0_Out_1, _Smoothstep_E4CAAC7_Out_3);
                float _Property_AACC4CF1_Out_0 = Vector1_A5060078;
                float _Multiply_3CA1059A_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_AACC4CF1_Out_0, _Multiply_3CA1059A_Out_2);
                float2 _TilingAndOffset_7C3A3642_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_F51983B5_Out_3.xy), float2 (1, 1), (_Multiply_3CA1059A_Out_2.xx), _TilingAndOffset_7C3A3642_Out_3);
                float _Property_FBDDB569_Out_0 = Vector1_87E56D94;
                float _GradientNoise_981171A6_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_7C3A3642_Out_3, _Property_FBDDB569_Out_0, _GradientNoise_981171A6_Out_2);
                float _Property_C43FBF59_Out_0 = Vector1_91381CE2;
                float _Multiply_3D766C6C_Out_2;
                Unity_Multiply_float(_GradientNoise_981171A6_Out_2, _Property_C43FBF59_Out_0, _Multiply_3D766C6C_Out_2);
                float _Add_77D7ABA7_Out_2;
                Unity_Add_float(_Smoothstep_E4CAAC7_Out_3, _Multiply_3D766C6C_Out_2, _Add_77D7ABA7_Out_2);
                float _Add_815A81E9_Out_2;
                Unity_Add_float(1, _Property_C43FBF59_Out_0, _Add_815A81E9_Out_2);
                float _Divide_4F5D0EE7_Out_2;
                Unity_Divide_float(_Add_77D7ABA7_Out_2, _Add_815A81E9_Out_2, _Divide_4F5D0EE7_Out_2);
                float3 _Multiply_FFAF1274_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_4F5D0EE7_Out_2.xxx), _Multiply_FFAF1274_Out_2);
                float3 _Multiply_3BA51423_Out_2;
                Unity_Multiply_float((_Property_AE65DA6E_Out_0.xxx), _Multiply_FFAF1274_Out_2, _Multiply_3BA51423_Out_2);
                float3 _Add_B5E099_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_3BA51423_Out_2, _Add_B5E099_Out_2);
                float3 _Add_398E3340_Out_2;
                Unity_Add_float3(_Multiply_88A97C10_Out_2, _Add_B5E099_Out_2, _Add_398E3340_Out_2);
                description.VertexPosition = _Add_398E3340_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpacePosition;
                float4 ScreenPosition;
            };
            
            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float _SceneDepth_13177C16_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_13177C16_Out_1);
                float4 _ScreenPosition_B0D02E3D_Out_0 = IN.ScreenPosition;
                float _Split_A61C2887_R_1 = _ScreenPosition_B0D02E3D_Out_0[0];
                float _Split_A61C2887_G_2 = _ScreenPosition_B0D02E3D_Out_0[1];
                float _Split_A61C2887_B_3 = _ScreenPosition_B0D02E3D_Out_0[2];
                float _Split_A61C2887_A_4 = _ScreenPosition_B0D02E3D_Out_0[3];
                float _Subtract_592D5B7_Out_2;
                Unity_Subtract_float(_Split_A61C2887_A_4, 1, _Subtract_592D5B7_Out_2);
                float _Subtract_2F543E42_Out_2;
                Unity_Subtract_float(_SceneDepth_13177C16_Out_1, _Subtract_592D5B7_Out_2, _Subtract_2F543E42_Out_2);
                float _Property_D58C37C7_Out_0 = Vector1_BEEE60AF;
                float _Divide_A1D0D2B8_Out_2;
                Unity_Divide_float(_Subtract_2F543E42_Out_2, _Property_D58C37C7_Out_0, _Divide_A1D0D2B8_Out_2);
                float _Saturate_24C694F6_Out_1;
                Unity_Saturate_float(_Divide_A1D0D2B8_Out_2, _Saturate_24C694F6_Out_1);
                surface.Alpha = _Saturate_24C694F6_Out_1;
                surface.AlphaClipThreshold = 0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            
            
            
            
                output.WorldSpacePosition =          input.positionWS;
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
            ENDHLSL
        }
        
    }
    FallBack "Hidden/Shader Graph/FallbackError"
}
