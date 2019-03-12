﻿/*
 *  The MIT License
 *
 *  Copyright 2018 whiteflare.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 *  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 *  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 *  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
Shader "UnlitWF/WF_MatcapShadows_Texture" {

    /*
     * authors:
     *      ver:2019/03/07 whiteflare,
     */

    Properties {
        // 基本
        [Header(Base)]
            _MainTex        ("Main Texture", 2D) = "white" {}
        [Enum(OFF,0,FRONT,1,BACK,2)]
            _CullMode       ("Cull Mode", int) = 2
        [Enum(OFF,0,BRIGHT,80,DARK,97,BLACK,100)]
            _GL_Level       ("Anti-Glare", Float) = 0

        // 色変換
        [Header(Color Change)]
        [Toggle(_CL_ENABLE)]
            _CL_Enable      ("[CL] Enable", Float) = 0
        [ToggleNoKwd]
            _CL_Monochrome  ("[CL] monochrome", Range(0, 1)) = 0
            _CL_DeltaH      ("[CL] Hur", Range(0, 1)) = 0
            _CL_DeltaS      ("[CL] Saturation", Range(-1, 1)) = 0
            _CL_DeltaV      ("[CL] Brightness", Range(-1, 1)) = 0

        // 法線マップ
        [Header(NormalMap)]
        [Toggle(_NM_ENABLE)]
            _NM_Enable      ("[NM] Enable", Float) = 0
        [NoScaleOffset]
            _BumpMap        ("[NM] NormalMap Texture", 2D) = "bump" {}
            _NM_Power       ("[NM] Shadow Power", Range(0, 1)) = 0.25

        // Matcapハイライト
        [Header(HighLight and Shadow Matcap)]
        [Toggle(_HL_ENABLE)]
            _HL_Enable      ("[HL] Enable", Float) = 0
        [NoScaleOffset]
            _HL_MatcapTex   ("[HL] Matcap Sampler", 2D) = "gray" {}
            _HL_MedianColor ("[HL] Median Color", Color) = (0.5, 0.5, 0.5, 1)
            _HL_Range       ("[HL] Matcap Range (Tweak)", Range(0, 2)) = 1
            _HL_Power       ("[HL] Power", Range(0, 2)) = 1
        [NoScaleOffset]
            _HL_MaskTex     ("[HL] Mask Texture", 2D) = "white" {}
        [Toggle(_HL_SOFT_SHADOW)]
            _HL_SoftShadow  ("[HL] Soft Shadow Enable", Float) = 1
        [Toggle(_HL_SOFT_LIGHT)]
            _HL_SoftLight   ("[HL] Soft Light Enable", Float) = 0

        // Overlay Texture
        [Header(Overlay Texture)]
        [Toggle(_OL_ENABLE)]
            _OL_Enable      ("[OL] Enable", Float) = 0
            _OL_OverlayTex  ("[OL] Texture", 2D) = "white" {}
        [Enum(MAINTEX_UV,0,VIEW_XY,1)]
            _OL_ScreenType  ("[OL] Screen Space", Float) = 0
        [Enum(ALPHA,ADD,MUL)]
            _OL_BlendType   ("[OL] Blend Type", Float) = 0
            _OL_Power       ("[OL] Blend Power", Range(0, 1)) = 1
            _OL_Scroll_U    ("[OL] U Scroll", Float) = 0
            _OL_Scroll_V    ("[OL] V Scroll", Float) = 0

        // EmissiveScroll
        [Header(Emissive Scroll)]
        [Toggle(_ES_ENABLE)]
            _ES_Enable      ("[ES] Enable", Float) = 0
        [HDR]
            _ES_Color       ("[ES] Emissive Color", Color) = (1, 1, 1, 1)
        [NoScaleOffset]
            _ES_MaskTex     ("[ES] Mask Texture", 2D) = "white" {}
        [Enum(EXCITATION,0,SAWTOOTH_WAVE,1,SIN_WAVE,2,ALWAYS_ON,3)]
            _ES_Shape       ("[ES] Wave Type", Float) = 0
            _ES_Direction   ("[ES] Direction", Vector) = (0, -10, 0, 0)
            _ES_LevelOffset ("[ES] LevelOffset", Range(-1, 1)) = 0
            _ES_Sharpness   ("[ES] Sharpness", Range(0, 4)) = 1
            _ES_Speed       ("[ES] ScrollSpeed", Range(0, 8)) = 2
    }

    SubShader {
        Tags {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
            "LightMode" = "ForwardBase"
        }

        Pass {
            Cull [_CullMode]

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #pragma target 3.0

            #pragma shader_feature _CL_ENABLE
            #pragma shader_feature _NM_ENABLE
            #pragma shader_feature _HL_ENABLE
            #pragma shader_feature _HL_SOFT_SHADOW
            #pragma shader_feature _HL_SOFT_LIGHT
            #pragma shader_feature _OL_ENABLE
            #pragma shader_feature _ES_ENABLE

            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "WF_MatcapShadows.cginc"

            ENDCG
        }
    }

    CustomEditor "UnlitWF.ShaderCustomEditor"
}
