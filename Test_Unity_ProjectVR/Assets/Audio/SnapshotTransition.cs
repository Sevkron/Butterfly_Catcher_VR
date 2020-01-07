using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

public class SnapshotTransition : MonoBehaviour
{
    public AudioMixer audioMixer;
    public AudioMixerSnapshot[] snapshots;
    public float[] timeToReach;
    public float timeToReachTampon;
    public float transitionTime;
    public AudioSource plaineAmbiance;
    public AudioSource japonAmbiance;

    void Start()
    {

    }

    void Update()
    {
        if (Input.GetKeyDown("e"))
        {
            audioMixer.TransitionToSnapshots(snapshots, timeToReach, transitionTime);
            timeToReachTampon = timeToReach[0];
            timeToReach[0] = timeToReach[1];
            timeToReach[1] = timeToReachTampon;
            StartCoroutine(WaitToCutSong());
            
        }


        IEnumerator WaitToCutSong()
        {
            yield return new WaitForSeconds(transitionTime/2);
            if (timeToReach[0] == 1)
            {
                plaineAmbiance.Play();
                japonAmbiance.Stop();
            }
            else
            {
                japonAmbiance.Play();
                plaineAmbiance.Stop();
            }
        }
    }

}
