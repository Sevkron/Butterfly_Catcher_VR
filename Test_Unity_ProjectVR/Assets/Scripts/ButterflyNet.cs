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

    void Awake()
    {
        if(captureMinigamePool == null)
            captureMinigamePool = GameObject.Find("CaptureMinigamePool").GetComponent<CaptureMinigamePool>();
            Debug.Log("Please set capture minigame pool");
    }

    void OnTriggerEnter(Collider other)
    {
        if(other.gameObject == exitedGameObject )
        {
            if(exitedGameObject.CompareTag("Butterfly"))
            {
                //Old Method
                butterflyBehaviorTree = exitedGameObject.GetComponentInParent<BehaviorTree>();
                exitedGameObject.GetComponent<YMovement>().GoToDefaultPos();
                exitedGameObject.GetComponentInParent<NavMeshAgent>().enabled = false;
                Destroy(exitedGameObject.GetComponent<Rigidbody>()); //Necessaire
                butterflyBehaviorTree.SendEvent<object>("IsCapturedNet", IsCaptured);
                int i = exitedGameObject.GetComponent<YMovement>().difficultyLevel;
                captureMinigamePool.SpawnSph(i);

            }else
            {
                Destroy(exitedGameObject);
            }
        }
    }
}
