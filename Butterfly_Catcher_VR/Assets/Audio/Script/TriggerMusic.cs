using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;


public class TriggerMusic : MonoBehaviour
{
    public int numberToSwitchBiome;
    public int biomeValue;
    public GameObject AudioManager;

    private void OnTriggerEnter(Collider other)
    {
        if(AudioManager == null)
        {
            AudioManager = FindObjectOfType<AudioManager>().gameObject;
        }
        for (int i =0; i < 4; i ++ )
        {
            if (AudioManager.GetComponent<SnapshotTransition>().timeToReach[i] == 1)
            {
                biomeValue = i;
            }
        }

        if (other.gameObject.tag == "Player" && biomeValue != numberToSwitchBiome)
        {
            AudioManager.GetComponent<SnapshotTransition>().timeToReach[biomeValue] = 0;
            AudioManager.GetComponent<SnapshotTransition>().timeToReach[numberToSwitchBiome] = 1;
            AudioManager.GetComponent<SnapshotTransition>().audioMixer.TransitionToSnapshots(AudioManager.GetComponent<SnapshotTransition>().snapshots, AudioManager.GetComponent<SnapshotTransition>().timeToReach, AudioManager.GetComponent<SnapshotTransition>().transitionTime);
        }

    }
}
