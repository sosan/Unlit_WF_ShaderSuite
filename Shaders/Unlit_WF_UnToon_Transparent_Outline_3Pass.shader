﻿/*
 *  The MIT License
 *
 *  Copyright 2018-2019 whiteflare.
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
Shader "UnlitWF/WF_UnToon_Transparent_Outline_3Pass" {

    /*
     * authors:
     *      ver:2019/05/18 whiteflare,
     */

    Properties {
        // 基本
        [Header(Base)]
            _MainTex        ("Main Texture", 2D) = "white" {}
        [HDR]
            _Color          ("Color", Color) = (1, 1, 1, 1)

        // Lit
        [Header(Lit)]
        [Enum(OFF,0,BRIGHT,80,DARK,97,BLACK,100)]
            _GL_Level       ("Anti-Glare", Float) = 97
            _GL_BrendPower  ("Blend Light Color", Range(0, 1)) = 0.8
        [Toggle(_)]
            _GL_CastShadow  ("Cast Shadows", Range(0, 1)) = 1

        // Alpha
        [Header(Transparent Alpha)]
        [Enum(MAIN_TEX_ALPHA,0,MASK_TEX_RED,1,MASK_TEX_ALPHA,2)]
            _AL_Source      ("[AL] Alpha Source", Float) = 0
        [NoScaleOffset]
            _AL_MaskTex     ("[AL] Alpha Mask Texture", 2D) = "white" {}
            _AL_Power       ("[AL] Power", Range(0, 2)) = 1.0
            _AL_CutOff      ("[AL] Cutoff Threshold", Range(0, 1)) = 0.9
        [Enum(OFF,0,ON,1)]
            _AL_ZWrite      ("[AL] ZWrite", int) = 0

        // 色変換
        [Header(Color Change)]
        [Toggle(_)]
            _CL_Enable      ("[CL] Enable", Float) = 0
        [Toggle(_)]
            _CL_Monochrome  ("[CL] monochrome", Range(0, 1)) = 0
            _CL_DeltaH      ("[CL] Hur", Range(0, 1)) = 0
            _CL_DeltaS      ("[CL] Saturation", Range(-1, 1)) = 0
            _CL_DeltaV      ("[CL] Brightness", Range(-1, 1)) = 0

        // 法線マップ
        [Header(NormalMap)]
        [Toggle(_)]
            _NM_Enable      ("[NM] Enable", Float) = 0
        [NoScaleOffset]
            _BumpMap        ("[NM] NormalMap Texture", 2D) = "bump" {}
            _BumpScale      ("[NM] Bump Scale", Range(0, 2)) = 1.0
            _NM_Power       ("[NM] Shadow Power", Range(0, 1)) = 0.25

        // メタリックマップ
        [Header(Metallic)]
        [Toggle(_)]
            _MT_Enable      ("[MT] Enable", Float) = 0
            _MT_Metallic    ("[MT] Metallic", Range(0, 1)) = 0.5
            _MT_Smoothness  ("[MT] Smoothness", Range(0, 1)) = 0.5
            _MT_BlendNormal ("[MT] Blend Normal", Range(0, 1)) = 0.1
            _MT_BlendType   ("[MT] Blend Type (MUL/ADD)", Range(0, 1)) = 0
        [Toggle(_)]
            _MT_Monochrome  ("[MT] Monochrome Reflection", Range(0, 1)) = 1
        [Toggle(_)]
            _MT_Specular    ("[MT] Specular", Range(0, 1)) = 0
        [NoScaleOffset]
            _MT_MaskTex     ("[MT] MetallicMap Texture", 2D) = "white" {}
        [Toggle(_)]
            _MT_InvMaskVal  ("[MT] Invert Mask Value", Range(0, 1)) = 0

        // Matcapハイライト
        [Header(Light Matcap)]
        [Toggle(_)]
            _HL_Enable      ("[HL] Enable", Float) = 0
        [Enum(MEDIAN_CAP,0,LIGHT_CAP,1)]
            _HL_CapType     ("[HL] Matcap Type", Float) = 0
        [NoScaleOffset]
            _HL_MatcapTex   ("[HL] Matcap Sampler", 2D) = "gray" {}
            _HL_MatcapColor ("[HL] Matcap Color", Color) = (0.5, 0.5, 0.5, 1)
            _HL_Power       ("[HL] Power", Range(0, 2)) = 1
            _HL_BlendNormal ("[HL] Blend Normal", Range(0, 1)) = 0.1
        [HideInInspector]
            _HL_Range       ("[HL] Matcap Range (Tweak)", Range(0, 2)) = 1
        [NoScaleOffset]
            _HL_MaskTex     ("[HL] Mask Texture", 2D) = "white" {}
        [Toggle(_)]
            _HL_InvMaskVal  ("[HL] Invert Mask Value", Range(0, 1)) = 0

        // 階調影
        [Header(ToonShade)]
        [Toggle(_)]
            _TS_Enable      ("[SH] Enable", Float) = 0
            _TS_BaseColor   ("[SH] Base Color", Color) = (1, 1, 1, 1)
        [NoScaleOffset]
            _TS_BaseTex     ("[SH] Base Shade Texture", 2D) = "white" {}
            _TS_1stColor    ("[SH] 1st Shade Color", Color) = (0.7, 0.7, 0.9, 1)
        [NoScaleOffset]
            _TS_1stTex      ("[SH] 1st Shade Texture", 2D) = "white" {}
            _TS_2ndColor    ("[SH] 2nd Shade Color", Color) = (0.5, 0.5, 0.8, 1)
        [NoScaleOffset]
            _TS_2ndTex      ("[SH] 2nd Shade Texture", 2D) = "white" {}
            _TS_1stPower    ("[SH] 1st Shade Power", Range(0, 2)) = 1
            _TS_2ndPower    ("[SH] 2nd Shade Power", Range(0, 2)) = 1
            _TS_1stBorder   ("[SH] 1st Border", Range(0, 1)) = 0.4
            _TS_2ndBorder   ("[SH] 2nd Border", Range(0, 1)) = 0.2
            _TS_Feather     ("[SH] Feather", Range(0, 0.2)) = 0.05
            _TS_BlendNormal ("[SH] Blend Normal", Range(0, 1)) = 0.1
        [NoScaleOffset]
            _TS_MaskTex     ("[SH] BoostLight Mask Texture", 2D) = "black" {}
        [Toggle(_)]
            _TS_InvMaskVal  ("[SH] Invert Mask Value", Range(0, 1)) = 0

        // リムライト
        [Header(RimLight)]
        [Toggle(_)]
            _TR_Enable      ("[RM] Enable", Float) = 0
            _TR_Color       ("[RM] Rim Color", Color) = (0.8, 0.8, 0.8, 1)
            _TR_PowerTop    ("[RM] Power Top", Range(0, 0.5)) = 0.1
            _TR_PowerSide   ("[RM] Power Side", Range(0, 0.5)) = 0.1
            _TR_PowerBottom ("[RM] Power Bottom", Range(0, 0.5)) = 0.1
        [NoScaleOffset]
            _TR_MaskTex     ("[RM] RimLight Mask Texture", 2D) = "white" {}
        [Toggle(_)]
            _TR_InvMaskVal  ("[RM] Invert Mask Value", Range(0, 1)) = 0

        // EmissiveScroll
        [Header(Emissive Scroll)]
        [Toggle(_)]
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
        [Enum(OFF,0,FRONT,1,BACK,2)]
            _ES_CullMode    ("[ES] Cull Mode", int) = 2
            _ES_Z_Shift     ("[ES] Z-shift", Range(0, 1)) = 0.5

        // アウトライン
        [Header(Outline)]
        [Toggle(_)]
            _TL_Enable      ("[LI] Enable", Float) = 0
            _TL_LineColor   ("[LI] Line Color", Color) = (0, 0, 0, 0.8)
            _TL_LineWidth   ("[LI] Line Width", Range(0, 0.5)) = 0.05
        [NoScaleOffset]
            _TL_MaskTex     ("[LI] Outline Mask Texture", 2D) = "white" {}
        [Toggle(_)]
            _TL_InvMaskVal  ("[LI] Invert Mask Value", Float) = 0
            _TL_Z_Shift     ("[LI] Z-shift (tweak)", Range(0, 1)) = 0.5
    }

    SubShader {
        Tags {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "DisableBatching" = "True"
        }

        GrabPass { "_UnToonTransparentOutlineCanceller" }
        UsePass "UnlitWF/WF_UnToon_Transparent_Outline/OUTLINE"
        UsePass "UnlitWF/WF_UnToon_Transparent_Outline/OUTLINE_CANCELLER"

        UsePass "UnlitWF/WF_UnToon_Transparent3Pass/MAIN_OPAQUE"
        UsePass "UnlitWF/WF_UnToon_Transparent3Pass/MAIN_BACK"
        UsePass "UnlitWF/WF_UnToon_Transparent3Pass/MAIN_FRONT"
        UsePass "UnlitWF/WF_UnToon_Transparent3Pass/EMISSIVE_SCROLL"
        UsePass "UnlitWF/WF_UnToon_Transparent3Pass/SHADOWCASTER"
    }

    CustomEditor "UnlitWF.ShaderCustomEditor"
}
