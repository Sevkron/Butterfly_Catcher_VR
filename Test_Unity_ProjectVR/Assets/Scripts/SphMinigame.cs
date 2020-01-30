using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class SphMinigame : MonoBehaviour
{
    public SphereInt[] sphMinigame;
    public float timer;

    private IEnumerator Delay;

    private int i = 0;
    // Start is called before the first frame update
    void Awake()
    {
    }

    // Update is called once per frame
    void Update()
    {
        
        //sphMinigame[i].StartTimer(timer);

        for(int i = 0; i <= sphMinigame.Length; i++)
        {
            sphMinigame[i].StartTimer(timer);

            if(sphMinigame[i].StartTimer(timer) == false)
            {
                Debug.Log("returned false");
            }else
            {
                
            }
        }
    }
}
