using System.Collections;
using System.Collections.Generic;
using UnityEngine.Audio;
using System;
using UnityEngine;

[System.Serializable]
public class Sound 
{
    public string name;

    public AudioClip clip;

    [Range(0f, 1f)]
    public float volume;
    [Range(0.1f, 3f)]
    public float pitch;

    public bool loop;

    public AudioSource source;

    void Awake()
    {
        if(source == null)
        {
            Debug.Log("No audio source outputy for" + name);
        }
    }

}
