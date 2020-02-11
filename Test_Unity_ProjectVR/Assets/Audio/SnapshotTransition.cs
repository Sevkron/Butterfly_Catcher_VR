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
    public int tamponI;
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
            timeToReachTampon = timeToReach[0];
            timeToReach[0] = timeToReach[1];
            timeToReach[1] = timeToReachTampon;
            audioMixer.TransitionToSnapshots(snapshots, timeToReach, transitionTime);
            StartCoroutine(WaitToCutSong());  
        }

        if (Input.GetKeyDown("r")) // JaponGrotte
        {
            timeToReachTampon = timeToReach[1];
            timeToReach[1] = timeToReach[2];
            timeToReach[2] = timeToReachTampon;
            audioMixer.TransitionToSnapshots(snapshots, timeToReach, transitionTime);
            StartCoroutine(WaitToCutSong());
        }

        if (Input.GetKeyDown("t")) // JaponClairière
        {
            timeToReachTampon = timeToReach[1];
            timeToReach[1] = timeToReach[3];
            timeToReach[3] = timeToReachTampon;
            audioMixer.TransitionToSnapshots(snapshots, timeToReach, transitionTime);
            StartCoroutine(WaitToCutSong());
        }
        if (Input.GetKeyDown("y")) // EntrerDansPhaseCapture
        {
            
            for (int i =0; i < 5 ; i++)
            {
                if (timeToReach[i] == 1)
                {
                    print("i = " + i);
                    tamponI = i;
                    timeToReach[i] = 0;
                }

          
            }
            timeToReachTampon = 0;
            timeToReach[4] = 1;
            audioMixer.TransitionToSnapshots(snapshots, timeToReach, transitionTime);
        }
        if (Input.GetKeyDown("u")) // SortirDePhaseCapture
        {
            timeToReachTampon = 0;
            timeToReach[tamponI] = 1;
            timeToReach[4] = 0;
            
        }





        IEnumerator WaitToCutSong()
        {
            yield return new WaitForSeconds(transitionTime/2);
            if (timeToReach[0] == 0) //Plaine
            {
                plaineAmbiance.Play();
                japonAmbiance.Stop();
                grotteAmbiance.Stop();
                clairiereAmbiance.Stop();
            }
            if (timeToReach[1] == 0) //Japon
            {
                japonAmbiance.Play();
                plaineAmbiance.Stop();
                grotteAmbiance.Stop();
                clairiereAmbiance.Stop();
            }
            if (timeToReach[2] == 0) //Grotte
            {
                japonAmbiance.Stop();
                plaineAmbiance.Stop();
                grotteAmbiance.Play();
                clairiereAmbiance.Stop();
            }
            if (timeToReach[3] == 0) //Clairiere
            {
                japonAmbiance.Stop();
                plaineAmbiance.Stop();
                grotteAmbiance.Stop();
                clairiereAmbiance.Play();
            }
        }
    }

}
