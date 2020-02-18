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
        if(m_captureMinigamePool == null)
            m_captureMinigamePool = GameObject.Find("CaptureMinigamePool").GetComponent<CaptureMinigamePool>();
    }   
    void OnEnable()
    {
        i = 0;
        sphMinigame[i].StartTimer(timer, false);
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
        //Debug.Log("Array is of length : " + sphMinigame.Length);
        //Debug.Log("i is equal to : " + i);

        if(i == sphMinigame.Length - 1)
        {
            sphMinigame[i].StartTimer(timer, true);
            Debug.Log("Start final sphere");
            
        }else if(i < sphMinigame.Length - 1)
        {
            sphMinigame[i].StartTimer(timer, false);
            Debug.Log("Caught sphere success");
        }
        else
        {
            m_captureMinigamePool.CaughtButterfly();
            Debug.Log("That was the final sphere");
            Destroy(this.gameObject);
        }
    }
}
