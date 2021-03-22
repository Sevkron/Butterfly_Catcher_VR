﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FirstNetDetect : MonoBehaviour
{
    public ButterflyNet butterflyNet;
    private IEnumerator butterflyCounter;
    public float m_timeToCatch;
    //public GameObject detectedButterfly;
    void Start()
    {
        if(butterflyNet == null)
            GetComponentInParent<ButterflyNet>();
        butterflyCounter = ButterflyCounter(m_timeToCatch);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    
    void OnTriggerExit(Collider other)
    {
        if(other.gameObject.CompareTag("Butterfly"))
        {
            butterflyNet.exitedGameObject = other.gameObject;
            Debug.Log("Butterfly Exit");
            StartCoroutine(butterflyCounter);
        }else if(other.gameObject.CompareTag("Sphere"))
        {
            butterflyNet.exitedGameObject = other.gameObject;
        }
    }

    private IEnumerator ButterflyCounter(float timer)
    {
        yield return new WaitForSeconds(timer);
        butterflyNet.exitedGameObject = null;
        Debug.Log("Butterfly forgotten");
    }
}
