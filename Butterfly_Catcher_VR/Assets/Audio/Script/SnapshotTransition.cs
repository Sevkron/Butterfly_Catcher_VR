using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using DG.Tweening;
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
    public GameObject audioSourceMusic;

    void Start()
    {

    }

    void Update()
    {
        /*if (Input.GetKeyDown("e")) // JaponPlaine
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

        }*/
        if (Input.GetKeyDown("y")) // EntrerDansPhaseCapture
        {

            audioMixer.DOSetFloat("VolMusic", -80, 3);
            audioMixer.DOSetFloat("VolCaptureMusic", 0, 3);


            /* for (int i =0; i < 5 ; i++)
             {
                 if (timeToReach[i] == 1)
                 {
                     tamponI = i;
                     timeToReach[i] = 0;
                 }
             }

             timeToReachTampon = 0;
             timeToReach[4] = 1;
             /*audioMixer.SetFloat("AmbiancePlaineVol", -80);
             audioMixer.SetFloat("AmbianceJaponVol", -80);
             audioMixer.SetFloat("AmbianceGrotteVol", -80);
             audioMixer.SetFloat("AmbianceClairiereVol", -80);
             audioMixer.TransitionToSnapshots(snapshots, timeToReach, transitionTime);


             if (tamponI == 0)
             {
                 print("TamponI = " + tamponI);
                 audioMixer.SetFloat("AmbiancePlaineVol",0);
             }else if (tamponI == 1)
             {
                 print("TamponI = " + tamponI);
                 audioMixer.SetFloat("AmbianceJaponVol", 0);
             }else if (tamponI == 2)
             {
                 print("TamponI = " + tamponI);
                 audioMixer.SetFloat("AmbianceGrotteVol", 0);
             }else if (tamponI == 3)
             {
                 print("TamponI = " + tamponI);
                 audioMixer.SetFloat("AmbianceClairiereVol", 0);
             }*/


        }


        if (Input.GetKeyDown("u")) // SortirDePhaseCapture
        {
            audioMixer.DOSetFloat("VolMusic", 0, 3);
            audioMixer.DOSetFloat("VolCaptureMusic", -80, 3);

            /*timeToReachTampon = 0;
            timeToReach[tamponI] = 1;
            timeToReach[4] = 0;
            audioMixer.TransitionToSnapshots(snapshots, timeToReach, transitionTime);
            */
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
            else if (timeToReach[1] == 1) //Japon
            {
                japonAmbiance.Play();
                plaineAmbiance.Stop();
                grotteAmbiance.Stop();
                clairiereAmbiance.Stop();
            }
            else if (timeToReach[2] == 1) //Grotte
            {
                grotteAmbiance.Play();
                japonAmbiance.Stop();
                plaineAmbiance.Stop();
                clairiereAmbiance.Stop();
            }
            else if (timeToReach[3] == 1) //Clairiere
            {
                clairiereAmbiance.Play();
                japonAmbiance.Stop();
                plaineAmbiance.Stop();
                grotteAmbiance.Stop();
            }
        }
    }

}
