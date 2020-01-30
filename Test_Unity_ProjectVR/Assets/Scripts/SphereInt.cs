using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class SphereInt : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public bool StartTimer(float timer)
    {
        GetComponent<SphereCollider>().enabled = true;
        transform.DOScale(new Vector3(0,0,0), timer);
        Debug.Log("Done");
        return true;
    }
}
