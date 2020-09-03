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
    private bool used = false;

    void Start()
    {
        SlotFull = false;
    }

    private void FixedUpdate()
    {
        if(ObjectStored != null && ObjectStored.GetComponent<Interactable>().attachedToHand)
        {
            GetComponent<SphereCollider>().enabled = true;
            SlotFull = false;
            //ObjectInteractibleScript.attachedToHand.hand
            ObjectStored = null;
        }
    }

    void OnTriggerStay(Collider other)
    {
        ObjectToCheck = other.gameObject;
        ObjectInteractibleScript = ObjectToCheck.GetComponent<Interactable>();
        //used = false;
        Rigidbody ObjectToCheckRigidbody = ObjectToCheck.GetComponent<Rigidbody>();

        if (ObjectInteractibleScript != null)
        {
            used = ObjectInteractibleScript.attachedToHand;
            

            if(SlotFull == false && ObjectToCheck.tag == m_objectTag)
            {
                ObjectToCheckRigidbody.isKinematic = true;
                ObjectStored = ObjectToCheck;
                ObjectToCheck.transform.position = transform.position;
                ObjectToCheck.transform.rotation = transform.rotation;
                ObjectStored.transform.SetParent(transform);

                if(used == false)
                {
                    //Debug.Log("Player placed Object" + ObjectStored);
                    GetComponent<SphereCollider>().enabled = false;
                    SlotFull = true;
                }
            }
            //Use the used bool to lock thing in place, if it is not held in hand and is in the placement collider, disable the collider then say slot is full
            //On trigger exit does not work when distance grab
        }
    }
    void OnTriggerExit(Collider other){
        if(other.gameObject == ObjectStored)
        {
            Debug.Log("Player took ");
            ObjectStored.GetComponent<Rigidbody>().isKinematic = false;
            GetComponent<SphereCollider>().enabled = true;
            //ObjectStored.transform.parent = null;
            ObjectStored = null;
            SlotFull = false;
        }
    }
  }
}


