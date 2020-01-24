using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using UnityEngine.AI;

public class ButterflyNet : MonoBehaviour
{
    public BoxCollider firstCollider;
    public SphereCollider secondCollider;
    public GameObject exitedButterfly;
    public BehaviorTree butterflyBehaviorTree;
    public Transform netTransform;
    public bool IsCaptured = true;

    void OnTriggerEnter(Collider other)
    {
        if(other.gameObject == exitedButterfly)
        {
            butterflyBehaviorTree = exitedButterfly.GetComponentInParent<BehaviorTree>();

            //A better Way
            exitedButterfly.GetComponent<YMovement>().GoToDefaultPos();

            exitedButterfly.GetComponentInParent<NavMeshAgent>().enabled = false;
            Destroy(exitedButterfly.GetComponent<Rigidbody>()); //Necessaire

            butterflyBehaviorTree.SendEvent<object>("IsCapturedNet", IsCaptured);
            //Debug.Log("Butterfly received");
        }
    }
}
