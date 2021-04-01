using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using UnityEngine.AI;

public class R_NetDetect : MonoBehaviour
{
    [SerializeField]
    private AudioManager audioManager;
    [SerializeField]
    private R_CaptureMinigame captureMinigameScript;
    public SharedBool SharedIsIdle;
    public bool IsCaptured = true;
    public BehaviorTree butterflyBehaviorTree;
    void Awake()
    {
        if(audioManager == null)
            {
                audioManager = FindObjectOfType<AudioManager>();
            }
        if(captureMinigameScript == null)
        {
            GameObject belt = GameObject.Find("BeltPlayer");
            captureMinigameScript = belt.GetComponentInChildren<R_CaptureMinigame>();
        }
    }
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
        if(other.gameObject.CompareTag("Butterfly"))
        {
            GameObject butterflyCaught = other.gameObject;
            audioManager.Play("CaptureChallengeStart", null);
            butterflyBehaviorTree = other.gameObject.GetComponentInParent<BehaviorTree>();
            SharedIsIdle = (SharedBool)butterflyBehaviorTree.GetVariable("IsIdle");
            SharedIsIdle = true;
            butterflyCaught.GetComponent<YMovement>().GoToDefaultPos();
            butterflyCaught.GetComponentInParent<NavMeshAgent>().enabled = false;
            butterflyBehaviorTree.SendEvent<object>("IsCapturedNet", IsCaptured);
            captureMinigameScript.SpawnChallenge(butterflyCaught.transform.parent.transform, butterflyCaught.GetComponent<YMovement>());
        }
    }
}
