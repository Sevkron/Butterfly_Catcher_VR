using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class SphereInt : MonoBehaviour
{
    IEnumerator delay;
    private bool activeOnce;
    // Start is called before the first frame update
    void Start()
    {
        activeOnce = true;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public bool StartTimer(float timer)
    {
        //Debug.Log("Started Timer");
        if(activeOnce == true)
        {
            GetComponent<SphereCollider>().enabled = true;
            activeOnce = false;
            StartCoroutine(Delay(timer));
            return true;
        }
        return false;
    }

    IEnumerator Delay(float timer)
    {
        transform.DOScale(new Vector3(0,0,0), timer);
        Debug.Log("Done");
        yield return new WaitForSeconds(timer); 
    }
}
