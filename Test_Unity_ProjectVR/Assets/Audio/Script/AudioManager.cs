using UnityEngine.Audio;
using System;
using UnityEngine;

public class AudioManager : MonoBehaviour
{
    public Sound[] sounds;

    public static AudioManager instance;

    void Awake ()
    {

        if (instance == null)
            instance = this;
        else
        {
            Destroy(gameObject);
            return;
        }

//        DontDestroyOnLoad(gameObject);
        foreach (Sound s in sounds)
        {
            s.source.clip = s.clip;

            s.source.volume = s.volume;

            s.source.loop = s.loop;
        }
    }

    public void Start()
    {
        DontDestroyOnLoad(gameObject);
    }
    public void Play (string name, AudioSource newAudioSource)
    {
        Sound s = Array.Find(sounds, sound => sound.name == name);
        if (newAudioSource != null)
        {
            s.source = newAudioSource;
        }
        s.source.clip = s.clip;
        if (s == null)
        {
            Debug.LogWarning("Sound: " + name + " not found!");
            return;
        }

        
        s.source.PlayOneShot(s.source.clip);

        /*A mettre dans le sript quand on veut lancer le son
         
        FindObjectOfType<AudioManager>().Play("NomDuSon", nomAudioSource);*/
        
    }
}
