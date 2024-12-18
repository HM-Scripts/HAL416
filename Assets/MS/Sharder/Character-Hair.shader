Shader "Zenn/Character-Hair"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        [Header(Stencil)]
        [Space]
        _StencilRef("Stencil Ref", Int) = 0
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
            Name "Hair"
            Stencil 
            {
                Ref [_StencilRef]
                Comp [_StencilComp]
                Pass [_StencilPassOp]
                Fail [_StencilFailOp]
                ZFail [_StencilZFailOp]
            }
            
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "CharacterPass.hlsl"
            ENDHLSL
        }
    }
}
