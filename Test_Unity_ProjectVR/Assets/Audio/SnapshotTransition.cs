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
    public AudioSource grotteAmbiance;
    public AudioSource clairiereAmbiance;

    void Start()
    {

    }

    void Update()
    {
        if (Input.GetKeyDown("e")) // JaponPlaine
        {
            audioMixer.TransitionToSnapshots(snapshots, timeToReach, transitionTime);
            timeToReachTampon = timeToReach[0];
            timeToReach[0] = timeToReach[1];
            timeToReach[1] = timeToReachTampon;
            StartCoroutine(WaitToCutSong());  
        }

        if (Input.GetKeyDown("r")) // JaponGrotte
        {
            audioMixer.TransitionToSnapshots(snapshots, timeToReach, transitionTime);
            timeToReachTampon = timeToReach[1];
            timeToReach[1] = timeToReach[2];
            timeToReach[2] = timeToReachTampon;
            StartCoroutine(WaitToCutSong());
        }

        if (Input.GetKeyDown("t")) // JaponClairière
        {
            audioMixer.TransitionToSnapshots(snapshots, timeToReach, transitionTime);
            timeToReachTampon = timeToReach[1];
            timeToReach[1] = timeToReach[3];
            timeToReach[3] = timeToReachTampon;
            StartCoroutine(WaitToCutSong());
        }


        IEnumerator WaitToCutSong()
        {
            yield return new WaitForSeconds(transitionTime/2);
            if (timeToReach[0] == 1) //Plaine
            {
                plaineAmbiance.Play();
                japonAmbiance.Stop();
                grotteAmbiance.Stop();
                clairiereAmbiance.Stop();
            }
            if (timeToReach[1] == 1) //Japon
            {
                japonAmbiance.Play();
                plaineAmbiance.Stop();
                grotteAmbiance.Stop();
                clairiereAmbiance.Stop();
            }
            if (timeToReach[2] == 1) //Grotte
            {
                japonAmbiance.Stop();
                plaineAmbiance.Stop();
                grotteAmbiance.Play();
                clairiereAmbiance.Stop();
            }
            if (timeToReach[3] == 1) //Clairiere
            {
                japonAmbiance.Stop();
                plaineAmbiance.Stop();
                grotteAmbiance.Stop();
                clairiereAmbiance.Play();
            }
        }
    }

}
