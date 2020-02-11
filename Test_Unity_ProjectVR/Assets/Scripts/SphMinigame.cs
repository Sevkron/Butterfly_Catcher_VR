using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class SphMinigame : MonoBehaviour
{
    public SphereInt[] sphMinigame;
    public float timer;
    private int i = 0;

    [HideInInspector] 
    private CaptureMinigamePool m_captureMinigamePool;

    void Start()
    {
        m_captureMinigamePool = GetComponentInParent<CaptureMinigamePool>();
    }   
    void OnEnable()
    {
        int i = 0;
        sphMinigame[i].StartTimer(timer);
        //Debug.Log("Started this thing");
    }

    public void MinigameFail()
    {
        m_captureMinigamePool.FreeButterfly();
        Destroy(this.gameObject);
    }

    public void CaughtSuccess()
    {
        
        i = i + 1;

        if(i < sphMinigame.Length)
        {
            sphMinigame[i].StartTimer(timer);
            Debug.Log("Caught Success");
        }
        else
        {
            m_captureMinigamePool.CaughtButterfly();
            Destroy(this.gameObject);
        }
    }
}
