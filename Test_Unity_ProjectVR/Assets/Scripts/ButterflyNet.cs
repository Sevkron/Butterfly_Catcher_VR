using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using UnityEngine.AI;

public class ButterflyNet : MonoBehaviour
{
    public BoxCollider firstCollider;
    public SphereCollider secondCollider;
    public GameObject exitedGameObject;
    public BehaviorTree butterflyBehaviorTree;
    public Transform netTransform;
    public bool IsCaptured = true;
    public CaptureMinigamePool captureMinigamePool;
    private ButterflyJar JarScript;
    public SharedBool SharedIsIdle;

    public float scale = 0.7f;


    void Awake()
    {
        if(captureMinigamePool == null)
            captureMinigamePool = GameObject.Find("CaptureMinigamePool").GetComponent<CaptureMinigamePool>();
            Debug.Log("Please set capture minigame pool");

        JarScript = GetComponentInChildren<ButterflyJar>();

        //SharedIsIdle = JarScript.SharedIsIdle;
    }

    void OnTriggerEnter(Collider other)
    {
        if(other.gameObject == exitedGameObject )
        {
            //var caughtButterfly = other.gameObject;
            if(other.gameObject.CompareTag("Butterfly") && captureMinigamePool.isNotInMinigame == true)
            {
                //Old Method
                butterflyBehaviorTree = other.gameObject.GetComponentInParent<BehaviorTree>();
                SharedIsIdle = JarScript.SharedIsIdle;
                SharedIsIdle = true;
                other.gameObject.GetComponent<YMovement>().GoToDefaultPos();
                other.gameObject.GetComponentInParent<NavMeshAgent>().enabled = false;
                Destroy(other.gameObject.GetComponent<Rigidbody>()); //Necessaire
                butterflyBehaviorTree.SendEvent<object>("IsCapturedNet", IsCaptured);
                captureMinigamePool.SpawnSph(other.gameObject);
                other.gameObject.transform.parent.transform.localScale = new Vector3(scale, scale, scale);

            }else
            {
                other.gameObject.GetComponent<SphereInt>().Caught();
            }
        }
        else
            Debug.Log("Didn't go through first collider");
    }
}
