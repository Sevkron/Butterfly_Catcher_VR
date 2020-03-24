using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace Valve.VR.InteractionSystem 
{
  public class ItemPlacement : MonoBehaviour
  {
    public Hand HandRightScript;
    public Hand HandLeftScript;

    public GameObject ObjectinLeftHand;
    public GameObject ObjectinRightHand;
    public string tag = "Jar";
    public GameObject ObjectStored;
     //   public Collider objecthandcollider;
    public bool SlotFull;

    void Start()
    {
        //ObjectinLeftHand = GetComponent<Hand>().currentAttachedObject;
        //ObjectinRightHand = GetComponent<Hand>().currentAttachedObject;
        SlotFull = false;
        //HandScript = GetComponent<Hand>();

    }

    void OnTriggerEnter(Collider other)
    {
            ObjectStored = other.gameObject;

            ObjectinLeftHand = GetComponent<Hand>().currentAttachedObject;
            ObjectinRightHand = GetComponent<Hand>().currentAttachedObject;

            if (SlotFull = false && other.gameObject.tag == tag && ObjectStored == ObjectinLeftHand)
            {
                HandLeftScript.DetachObject(ObjectStored);

                ObjectStored.transform.SetParent(this.transform);
                ObjectStored.transform.position = new Vector3(0, 0, 0);
                ObjectStored.transform.rotation = Quaternion.Euler(0, 0, 0);
                ObjectStored.GetComponent<Rigidbody>().isKinematic = true;

                SlotFull = true;
 
                Debug.Log("Detect Jar in slot");
            }

           else if (SlotFull = false && other.gameObject.tag == tag && other.gameObject == ObjectinRightHand)
            {
                HandRightScript.DetachObject(other.gameObject);

                ObjectStored.transform.SetParent(this.transform);
                ObjectStored.transform.position = new Vector3(0, 0, 0);
                ObjectStored.transform.rotation = Quaternion.Euler(0, 0, 0);
                ObjectStored.GetComponent<Rigidbody>().isKinematic = true;

                SlotFull = true;

                Debug.Log("Detect Jar in slot");
            }
        }

        private void OnTriggerExit(Collider other)
        {
            ObjectStored.GetComponent<Rigidbody>().isKinematic = false;
            SlotFull = false;
        }

    }
}


