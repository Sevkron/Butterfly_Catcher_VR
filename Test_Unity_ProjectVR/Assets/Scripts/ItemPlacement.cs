using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace Valve.VR.InteractionSystem 
{
  public class ItemPlacement : MonoBehaviour
  {

    public Transform jar;
    public Hand HandScript;

    public GameObject ObjectinHand;
    public bool SlotFull;

    void Start()
    {
        ObjectinHand = GetComponent<Hand>().currentAttachedObject;
        SlotFull = false;




    }


    void Update()
    {

    }

    void OnTriggerEnter(GameObject other)
    {
            other = ObjectinHand;
            HandScript = GetComponent<Hand>();

        if (SlotFull = false && other.tag == "Jar" )
        {
                HandScript.DetachObject(other);

            
            Debug.Log("Detect Jar in slot");
        }
    }

  }
}


