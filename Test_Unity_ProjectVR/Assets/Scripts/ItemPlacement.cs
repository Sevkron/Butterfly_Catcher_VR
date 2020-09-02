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
    private Interactable ObjectInteractibleScript;
     //   public Collider objecthandcollider;
    public bool SlotFull;

    void Start()
    {
        //ObjectinLeftHand = GetComponent<Hand>().currentAttachedObject;
        //ObjectinRightHand = GetComponent<Hand>().currentAttachedObject;
        SlotFull = false;
        //HandScript = GetComponent<Hand>();

    }

    /*void OnTriggerEnter(Collider other)
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
    }*/
    void OnTriggerStay(Collider other)
    {
        ObjectToCheck = other.gameObject;
        ObjectInteractibleScript = ObjectToCheck.GetComponent<Interactable>();
        bool used = false;

        if (ObjectInteractibleScript != null)
        {
            used = ObjectInteractibleScript.attachedToHand;
            if(SlotFull == false && ObjectToCheck.tag == m_objectTag)
            {
            /*if(used)
                ObjectToCheck.GetComponent<Rigidbody>().isKinematic = false;
            else*/
                ObjectToCheck.GetComponent<Rigidbody>().isKinematic = true;
                //GetComponent<SphereCollider>().enabled = false;
                //SlotFull = true; 
                ObjectStored = ObjectToCheck;
                ObjectToCheck.transform.position = transform.position;
                ObjectToCheck.transform.rotation = transform.rotation;
                ObjectStored.transform.SetParent(transform);
            }
            //Use the used bool to lock thing in place, if it is not held in hand and is in the placement collider, disable the collider then say slot is full
            //Use on trigger exit to reac5tivate the collider and say slot is not longer full
            //Maybe the Kinematics will figure themselves out ?
        }
    }
    void OnTriggerExit(Collider other){
        if(other.gameObject == ObjectStored)
        {
            ObjectStored.GetComponent<Rigidbody>().isKinematic = true;
            //ObjectStored.transform.parent = null;
            ObjectStored = null;
            SlotFull = false;

        }
    }
  }
}


