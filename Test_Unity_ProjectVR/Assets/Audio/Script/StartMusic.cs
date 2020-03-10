using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StartMusic : MonoBehaviour
{

    public int waitBetweenMusic;  // c'est le temps entre chaque musique
    public int numberOfMusic;
    public int biome;
    public GameObject AudioManager;
    public AudioSource[] musicAudioSource;
    public AudioClip[] listAudioClipMusic;
    public bool startCoroutineMusic;
    void Start()
    {
        startCoroutineMusic = true;
    }
    void Update()
    {
        if (startCoroutineMusic == true)
        {
            startCoroutineMusic = false;
            StartCoroutine(CoroutineMusic());
        }

    }

    IEnumerator CoroutineMusic()
    {
        waitBetweenMusic = Random.Range(120, 240); //Entre 3 et 6 min
        yield return new WaitForSeconds(waitBetweenMusic);
        for (int i = 0; i < 4; i++)
        {
            if (AudioManager.GetComponent<SnapshotTransition>().timeToReach[i] == 1)
            {
                biome = i;
            }
        }

        if (biome == 0) //Plaine
        {
            numberOfMusic = Random.Range(0, 2);
            musicAudioSource[biome].clip = listAudioClipMusic[numberOfMusic];
        }
        else if (biome == 1) //Japon
        {
            numberOfMusic = Random.Range(2, 4);
            musicAudioSource[biome].clip = listAudioClipMusic[numberOfMusic];

        }
        else if (biome == 2) //Grotte
        {
            musicAudioSource[biome].clip = listAudioClipMusic[4];
        }
        else if (biome == 3) //Clairiere
        {
            musicAudioSource[biome].clip = listAudioClipMusic[5];
        }

        musicAudioSource[biome].Play();
        yield return new WaitForSeconds(musicAudioSource[biome].clip.length);
        startCoroutineMusic = true;
    }
}
