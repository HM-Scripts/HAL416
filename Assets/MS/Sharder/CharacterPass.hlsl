#ifndef CHARACTER_PASS_INCLUDED
#define CHARACTER_PASS_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

CBUFFER_START(UnityPerMaterial)
sampler2D _MainTex; // ベースカラーテクスチャ
sampler2D _EyeMaskTex; // 眉をくり抜くマスクテクスチャ
half4 _EyeBrowColor; // 眉の色
float3 _CharacterFaceFront; // キャラクターの顔の正面
half _EyeMaskEdge1; // フェードがかかり始める角度 (cosの値を指定)
half _EyeMaskEdge2; // フェードがかかり終わる角度 (cosの値を指定)
CBUFFER_END

float cross2d(float2 a, float2 b)
{
    return (a.x * b.y - a.y * b.x);
}

struct appdata
{
    float4 vertex : POSITION; 
    float2 uv : TEXCOORD0;
};

struct v2f
{
    float4 vertex : SV_POSITION;
    float2 uv : TEXCOORD0;
    float eyeMask : TEXCOORD1; // 目じりをくり抜くマスク値
};

float remap(float x, float a, float b, float c, float d)
{
    return saturate((x - a) / (b - a)) * (d - c) + c;
}

v2f vert (appdata v)
{
    v2f o;
    o.vertex = TransformObjectToHClip(v.vertex); 
    o.uv = v.uv;
    
    float3 camFront = -UNITY_MATRIX_V[2];
    float2 camFrontXZ = -UNITY_MATRIX_V[2].xz;
    float2 faceFrontXZ = _CharacterFaceFront.xz;
    float isRightSide = step(0.0, cross2d(camFrontXZ, faceFrontXZ));
    o.eyeMask = lerp(step(0, v.vertex.x), step(v.vertex.x, 0), isRightSide);

    half dotFaceCamera = dot(_CharacterFaceFront, -camFront); 
    o.eyeMask *= remap(dotFaceCamera, _EyeMaskEdge1, _EyeMaskEdge2, 0.0, 1.0);
    o.eyeMask *= saturate(dotFaceCamera);
    return o;
}


half4 frag (v2f i) : SV_Target
{
    // カラーテクスチャのサンプリング
    half4 col = tex2D(_MainTex, i.uv);
    
    #ifdef CHARACTER_EYEBROW_PASS
    half4 mask = tex2D(_EyeMaskTex, i.uv);
    clip(mask.r - 0.001); // マスクが黒いところをくり抜く
    col *= _EyeBrowColor;
    col.a *= i.eyeMask;
    #endif
    
    return col;
}

#endif