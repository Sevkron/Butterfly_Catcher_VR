using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace Valve.VR.InteractionSystem 
{
  public class ItemPlacement : MonoBehaviour
  {
    public string m_objectTag;
    private GameObject ObjectToCheck;
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
            ObjectToCheck = other.gameObject;
            if(SlotFull == false && ObjectToCheck.tag == m_objectTag)
            {
                Debug.Log("Detaching " + ObjectToCheck);
                SlotFull = true;
                ObjectStored = ObjectToCheck;
                Hand attachedHand = ObjectToCheck.GetComponent<Interactable>().attachedToHand;
                attachedHand.DetachObject(ObjectStored);
                //attachedHand.AttachObject(ObjectStored, 0, 1, null);
                ObjectStored.GetComponent<Rigidbody>().isKinematic = true;
                
                //ObjectStored.transform.position = new Vector3(0, 0, 0);
                ObjectStored.transform.rotation = Quaternion.Euler(0, 0, 0);
                ObjectStored.transform.SetParent(this.transform);
            }

            /*ObjectinLeftHand = GetComponent<Hand>().currentAttachedObject;
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
            }*/
        }

        /*private void OnTriggerExit(Collider other)
        {
            ObjectStored.GetComponent<Rigidbody>().isKinematic = false;
            SlotFull = false;
        }*/

    }
}


