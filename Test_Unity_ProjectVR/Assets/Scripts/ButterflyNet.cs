using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using UnityEngine.AI;
using Valve.VR.InteractionSystem;

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
    public bool m_hasButterfly;
    public float scale = 0.7f;
    private GameObject belt;
    private Transform m_BeltNetTransform;
    public float m_MaxDistanceFromBelt;
    private AudioManager audioManager;
    void Start()
    {
        if(captureMinigamePool == null && m_BeltNetTransform == null)
            belt = GameObject.Find("BeltPlayer");
            captureMinigamePool = belt.GetComponentInChildren<CaptureMinigamePool>();
            m_BeltNetTransform = belt.transform.GetChild(1);
            Debug.Log("Please set capture minigame pool");
        //SharedIsIdle = JarScript.SharedIsIdle;
    }

    void Update()
    {
        if(m_BeltNetTransform)
        {
            if(Vector3.Distance(m_BeltNetTransform.position, transform.position) >= m_MaxDistanceFromBelt)
            {
                Debug.Log("Net too far from player");
                //Need to figure out how to attach to belt
                Rigidbody netRigidbody = GetComponent<Rigidbody>();
                gameObject.transform.position = m_BeltNetTransform.position;
                gameObject.transform.rotation = m_BeltNetTransform.rotation;
                netRigidbody.velocity = new Vector3 (0, 0, 0);
                netRigidbody.angularVelocity = new Vector3 (0, 0, 0);
                //gameObject.transform.SetParent(m_BeltNetTransform);
            }
        }
    }

    void OnTriggerStay(Collider other)
    {
        if(other.gameObject == exitedGameObject )
        {
            //var caughtButterfly = other.gameObject;
            if(other.gameObject.CompareTag("Butterfly") && captureMinigamePool.isNotInMinigame == true)
            {
                //Old Method
                GameObject butterflyCaught = other.gameObject;
                if(audioManager == null)
                {
                    audioManager = FindObjectOfType<AudioManager>();
                }
                audioManager.Play("CaptureChallengeStart", null);
                m_hasButterfly = true;
                butterflyBehaviorTree = other.gameObject.GetComponentInParent<BehaviorTree>();
                SharedIsIdle = (SharedBool)butterflyBehaviorTree.GetVariable("IsIdle");
                SharedIsIdle = true;
                butterflyCaught.GetComponent<YMovement>().GoToDefaultPos();
                butterflyCaught.GetComponentInParent<NavMeshAgent>().enabled = false;
                //Destroy(other.gameObject.GetComponent<Rigidbody>()); //Necessaire
                butterflyBehaviorTree.SendEvent<object>("IsCapturedNet", IsCaptured);
                captureMinigamePool.SpawnSph(other.gameObject);
                butterflyCaught.transform.parent.transform.localScale = new Vector3(scale, scale, scale);

            }else
            {
                other.gameObject.GetComponent<SphereInt>().Caught();
            }
        }
        else
            Debug.Log("Didn't go through first collider");
    }
}
