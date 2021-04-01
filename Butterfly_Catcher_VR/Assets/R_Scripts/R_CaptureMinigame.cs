using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class R_CaptureMinigame : MonoBehaviour
{   
    public bool isNotInMinigame = true;
    [SerializeField]
    private AudioManager audioManager;
    [SerializeField]
    private GameObject[] CaptureLevel0;
    [SerializeField]
    private GameObject[] CaptureIcons;
    void Awake()
    {
        if(audioManager == null)
        {
            audioManager = FindObjectOfType<AudioManager>();
        }
    }

    public void SpawnChallenge(Transform origin, YMovement butterflyScript)
    {
        isNotInMinigame = false;
        int i = Random.Range(0, CaptureLevel0.Length);
        Instantiate(CaptureLevel0[i], origin.position, origin.rotation, null);
    }
}
