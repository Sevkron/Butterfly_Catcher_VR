using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using UnityEngine.AI;
using Valve.VR.InteractionSystem;

public class ButterflyJar : MonoBehaviour
{
    public BehaviorTree butterflyBehaviorTree;

    

    //public GameObject jar;
    public bool hasButterfly;
    public string butterflyType;
    public GameObject ButterflyinJar;
    public bool Butterflycatched;
    public float scale = 0.2f;
    public YMovement yMoveScript;
    public SharedBool SharedIsIdle;
    private Player player;
    private AudioManager audioManager;
    public ParticleSystem m_newJarCaptureVFX;
    public ParticleSystem m_jarCaptureVFX;
    private void Start()
    {
        hasButterfly = false;
        Butterflycatched = false;
        
    }

    void OnTriggerEnter(Collider other)
    {
        //changer pour faire en sorte que le papillon est desactive par net, ne peut pas etre attrape par jar
        if(other.gameObject.CompareTag("Butterfly") && hasButterfly == false && other.gameObject.GetComponent<YMovement>().isWander == false)
        {
            if(audioManager == null)
            {
                audioManager = FindObjectOfType<AudioManager>();
            }
            StopCoroutine();
            audioManager.Play("CanvasButtonClick", null);
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

            //Send Event to IndexPanel
            player = Player.instance;
            player.GetComponent<CaughtIndexPanel>().CheckIfSpeciesExists(yMoveScript.stringButterflySpecies, this);
        }
    }

   

    public void FreeButterfly()
    {
        yMoveScript.GoBackToWander(true, 2.0f);
        Debug.Log("Delay start");
    }

    public void StopCoroutine()
    {
        StopCoroutine(yMoveScript.m_DelayCoroutine);
        Debug.Log("Delay stop");
    }
}
