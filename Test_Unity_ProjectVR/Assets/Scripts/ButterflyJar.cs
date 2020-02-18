using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using UnityEngine.AI;

public class ButterflyJar : MonoBehaviour
{
    public BehaviorTree butterflyBehaviorTree;



    //public GameObject jar;
    public bool hasButterfly;
    public GameObject ButterflyinJar;
    public bool Butterflycatched;
    
    public float scale = 0.2f;
    private YMovement yMoveScript;
    public SharedBool SharedIsIdle;

    private void Start()
    {
        hasButterfly = false;
        Butterflycatched = false;
    }

    void OnTriggerEnter(Collider other)
    {
        //changer pour faire en sorte que le papillon est desactive par net, ne peut pas etre attrape par jar
        if(other.gameObject.CompareTag("Butterfly") && hasButterfly == false)
        {
            ButterflyinJar = other.gameObject;
            hasButterfly = true;
            butterflyBehaviorTree = ButterflyinJar.GetComponentInParent<BehaviorTree>();
            SharedIsIdle = (SharedBool)butterflyBehaviorTree.GetVariable("IsIdle");
            SharedIsIdle = true;
            ButterflyinJar.GetComponentInParent<NavMeshAgent>().enabled = false;
            yMoveScript = ButterflyinJar.GetComponent<YMovement>();
            yMoveScript.GoToDefaultPos();
            yMoveScript.JarScript = this;
            ButterflyinJar.GetComponent<SphereCollider>().enabled = false;
            
            butterflyBehaviorTree.SendEvent<object>("IsCapturedJar", this.gameObject);
            ButterflyinJar.transform.parent.transform.localScale = new Vector3(scale, scale, scale);
            
        }
    }

   

    public void FreeButterfly()
    {
        StartCoroutine(yMoveScript.Delay());
        Debug.Log("Delay start");
    }

    public void StopCoroutine()
    {
        StopCoroutine(yMoveScript.Delay());
    }
}
