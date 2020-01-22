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
            butterflyBehaviorTree = exitedButterfly.GetComponent<BehaviorTree>();
            exitedButterfly.GetComponent<NavMeshAgent>().enabled = false;
            //Destroy(exitedButterfly.GetComponent<Rigidbody>()); //Voir si necessaire
            butterflyBehaviorTree.SetVariableValue("Transform", this.transform);
            butterflyBehaviorTree.SendEvent<object>("IsCapturedNet", IsCaptured);
            //Debug.Log("Butterfly received");
        }
    }
}
