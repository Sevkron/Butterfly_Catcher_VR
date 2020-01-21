using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using UnityEngine.AI;

public class ButterflyJar : MonoBehaviour
{
    public BehaviorTree butterflyBehaviorTree;
    

    //public GameObject jar;
    // Start is called before the first frame update
    

    private void Start()
    {
        //hasButterfly = 
    }
    void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.CompareTag("Butterfly"))
        {
            butterflyBehaviorTree = other.gameObject.GetComponent<BehaviorTree>();
            other.gameObject.GetComponent<NavMeshAgent>().enabled = false;
            Destroy(other.gameObject.GetComponent<Rigidbody>());
            butterflyBehaviorTree.SendEvent<object>("IsCapturedJar", this.gameObject);
            //hasButterfly = true;
        }

        //if (PapinJar & Jaropen)
    }
}
