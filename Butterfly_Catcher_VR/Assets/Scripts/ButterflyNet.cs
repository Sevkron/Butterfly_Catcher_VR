using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using UnityEngine.AI;
using Valve.VR.InteractionSystem;

public class ButterflyNet : MonoBehaviour
{
    /*public BoxCollider firstCollider;
    public SphereCollider secondCollider;*/
    private YMovement capturedButterflyYMoveScript;
    public GameObject exitedGameObject;
    public BehaviorTree butterflyBehaviorTree;
    public Transform netTransform;
    private GameObject cloth;
    public bool IsCaptured = true;
    public R_CaptureMinigame m_CaptureMinigamePool;
    private GameObject captureMinigameGO;
    private ButterflyJar JarScript;
    public SharedBool SharedIsIdle;
    public bool m_hasButterfly;
    public float scale = 0.7f;
    private GameObject belt;
    private Transform m_BeltNetTransform;
    public float m_MaxDistanceFromBelt;
    private AudioManager audioManager;
    void Awake()
    {
        if(m_BeltNetTransform == null)
            belt = GameObject.Find("BeltPlayer");
            m_BeltNetTransform = belt.transform.GetChild(1);
            Debug.Log("Please set belt");
        if(m_CaptureMinigamePool == null)
            captureMinigameGO = GameObject.Find("CaptureMinigame_V2");
            m_CaptureMinigamePool = captureMinigameGO.GetComponent<R_CaptureMinigame>();
            Debug.Log("Please set capture minigame pool");
        if(audioManager == null)
            audioManager = FindObjectOfType<AudioManager>();
            Debug.Log("Please set Audio manager");
        if(cloth == null)
            cloth = transform.Find("Net1/net_v2/NetCloth").gameObject;
    }

    void Update()
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

    void OnTriggerEnter(Collider other)
    {
        if(other.gameObject == exitedGameObject )
        {
            //var caughtButterfly = other.gameObject;
            if(other.gameObject.CompareTag("Butterfly") && m_CaptureMinigamePool.isNotInMinigame == true)
            {
                //Old Method
                GameObject butterflyCaught = other.gameObject;
                
                audioManager.Play("CaptureChallengeStart", null);
                m_hasButterfly = true;
                capturedButterflyYMoveScript = butterflyCaught.GetComponent<YMovement>();
                m_CaptureMinigamePool.SpawnChallenge(butterflyCaught.transform, capturedButterflyYMoveScript);
                butterflyBehaviorTree = other.gameObject.GetComponentInParent<BehaviorTree>();
                SharedIsIdle = (SharedBool)butterflyBehaviorTree.GetVariable("IsIdle");
                SharedIsIdle = true;
                capturedButterflyYMoveScript.GoToDefaultPos();
                butterflyCaught.GetComponentInParent<NavMeshAgent>().enabled = false;
                //Destroy(other.gameObject.GetComponent<Rigidbody>()); //Necessaire
                butterflyBehaviorTree.SendEvent<object>("IsCapturedNet", IsCaptured);
                //butterflyCaught.transform.parent.transform.localScale = new Vector3(scale, scale, scale);
            }else
            {
                other.gameObject.GetComponent<SphereInt>().Caught();
            }
        }
        else
            Debug.Log("Didn't go through first collider");
    }
    void UpdateNetColor(bool isOverButterfly)
    {
        if(isOverButterfly == true)
        {

        }
    }
}
