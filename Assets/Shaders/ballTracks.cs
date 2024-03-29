﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ballTracks : MonoBehaviour
{
    private RenderTexture splatmap;
    public Shader drawShader;
    private Material drawMaterial;
    private Material myMaterial;
    public GameObject _terrain;
    public Transform[] _ball;
    RaycastHit _groundHit;
    int _layerMask;
    [Range(1, 500)]
    public float _brushSize;
    [Range(0, 1)]
    public float _brushStrength;

    void Start()
    {
        _layerMask = LayerMask.GetMask("Ground");
        drawMaterial = new Material(drawShader);
        myMaterial = _terrain.GetComponent<MeshRenderer>().material;
        myMaterial.SetTexture("_Splat", splatmap = new RenderTexture(1024, 1024, 0, RenderTextureFormat.ARGBFloat));
    }

    void Update()
    {
        for (int i = 0; i < _ball.Length; i++)
        {
            if (Physics.Raycast(_ball[i].position, -Vector3.up, out _groundHit, 1f, _layerMask))
            {
                drawMaterial.SetVector("_Coordinate", new Vector4(_groundHit.textureCoord.x, _groundHit.textureCoord.y, 0, 0));
                drawMaterial.SetFloat("_Strength", _brushStrength);
                drawMaterial.SetFloat("_Size", _brushSize);
                RenderTexture temp = RenderTexture.GetTemporary(splatmap.width, splatmap.height, 0, RenderTextureFormat.ARGBFloat);
                Graphics.Blit(splatmap, temp);
                Graphics.Blit(temp, splatmap, drawMaterial);
                RenderTexture.ReleaseTemporary(temp);
            }
        }
    }
}
