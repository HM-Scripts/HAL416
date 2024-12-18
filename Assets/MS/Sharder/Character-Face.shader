Shader "Zenn/Character-Face"
{
    Properties
    {
        _EyeBrowColor ("Eyebrow Color", Color) = (1, 1, 1, 0.5)
        _MainTex ("Main Texture", 2D) = "white" {}
        _EyeMaskTex ("Eye Mask Texture", 2D) = "black" {}
        _EyeMaskEdge1 ("Eye Mask Edge 1", Range(0, 1)) = 0.4 // フェードがかかりはじめる角度 (角度ではなく、cosの値を指定)
        _EyeMaskEdge2 ("Eye Mask Edge 2", Range(0, 1)) = 0.0 // フェードがかかり終わる角度 (角度ではなく、cosの値を指定)
        
        [Header(EyeBrow Stencil)]
        [Space]
        _StencilRef("Stencil Ref", Int) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)]_StencilComp("Stencil Comp", Int) = 0
        [Enum(UnityEngine.Rendering.StencilOp)]_StencilPassOp("Stencil Pass", Int) = 0
        [Enum(UnityEngine.Rendering.StencilOp)]_StencilFailOp("Stencil Fail", Int) = 0
        [Enum(UnityEngine.Rendering.StencilOp)]_StencilZFailOp("Stenci ZFail", Int) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Name "Base"

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "CharacterPass.hlsl"
            
            ENDHLSL
        }
        
        Pass
        {
            Name "EyeBrow"
            
            Tags { "LightMode"="EyeBrow" }
            Stencil 
            {
                Ref [_StencilRef]
                Comp [_StencilComp]
                Pass [_StencilPassOp]
                Fail [_StencilFailOp]
                ZFail [_StencilZFailOp]
            }

            Blend SrcAlpha OneMinusSrcAlpha
            ZTest Off

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #define CHARACTER_EYEBROW_PASS
            #include "CharacterPass.hlsl"
            ENDHLSL
        }
    }
}