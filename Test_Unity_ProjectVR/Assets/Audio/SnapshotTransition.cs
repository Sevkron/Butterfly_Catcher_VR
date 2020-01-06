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

    void Start()
    {

    }

    void Update()
    {
        if (Input.GetKeyDown("e"))
        {
            audioMixer.TransitionToSnapshots(snapshots, timeToReach, 3.0f);
            timeToReachTampon = timeToReach[0];
            timeToReach[0] = timeToReach[1];
            timeToReach[1] = timeToReachTampon;
        }
    }

}
