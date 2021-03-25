using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class R_NetDetect : MonoBehaviour
{
    void OnCollisionStay(Collision collision)
    {
        Debug.Log("collided");
        foreach(ContactPoint contact in collision.contacts)
        {
            print(contact.thisCollider.name + " hit " + contact.otherCollider.name);
            // Visualize the contact point
            Debug.DrawRay(contact.point, contact.normal, Color.white);
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Butterfly")
        {
            Debug.Log("Caught a butterfly");
        }
    }
}
