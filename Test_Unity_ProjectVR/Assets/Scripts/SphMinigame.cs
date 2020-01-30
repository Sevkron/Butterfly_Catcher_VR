using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class SphMinigame : MonoBehaviour
{
    public SphereInt[] sphMinigame;
    public float timer;


    private int i = 0;
    // Start is called before the first frame update
    void Awake()
    {
    }

    void Start()
    {
        int i = 0;
        sphMinigame[i].StartTimer(timer);

        if(sphMinigame[i].StartTimer(timer))
        {
            i++;
            if(i == sphMinigame.Length)
            {
                Debug.Log("Destroyed");
                //Destroy(this.gameObject);
            }
            sphMinigame[i].StartTimer(timer);
        }
        else
        {
            Debug.Log("Destroyed");
            //Destroy(this.gameObject);
        }
    }

    // Update is called once per frame
    void Update()
    {
        //Debug.Log(sphMinigame.Length);
        /*for(int i = 0; i < sphMinigame.Length; i++)
        {
            sphMinigame[i].StartTimer(timer);
        }*/
    }
}
