using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManagerPapillodex : MonoBehaviour
{
    public AudioSource papillodexAudioSource;
    // Start is called before the first frame update
    void Start()
    {
        if(papillodexAudioSource = null)
            papillodexAudioSource = GetComponent<AudioSource>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
