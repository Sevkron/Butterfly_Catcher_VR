﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using Valve.VR;
using Valve.VR.InteractionSystem;
using UnityEngine.AI;
using DG.Tweening;

namespace Valve.VR.InteractionSystem.Sample
{
    public class OpenJar : MonoBehaviour
    {
        public Interactable interactable;

        public Animator animator;
         
        public SphereCollider sphereCollider; 

        public bool affectMaterial = false;

        public bool JarOpen;

        public BehaviorTree butterflyBehaviorTree;

        public GameObject ExitPoint;

        private ButterflyJar JarScript;

        private Vector3 ExitVector3;

        private Coroutine currentCoroutine;
        private bool pressOnce;

        //public bool hasButterfly;

        //public SteamVR_Action_Single gripSqueeze = SteamVR_Input.GetAction<SteamVR_Action_Single>("SqueezeTrigger");

        public SteamVR_Action_Single pinchSqueeze = SteamVR_Input.GetAction<SteamVR_Action_Single>("SqueezeTrigger");

        private void Awake()
        {
            if (interactable == null)
                interactable = GetComponent<Interactable>();

            if (animator == null)
                animator = GetComponentInChildren<Animator>();

            JarScript = GetComponentInChildren<ButterflyJar>();


            ExitVector3 = new Vector3(ExitPoint.transform.position.x , ExitPoint.transform.position.y , ExitPoint.transform.position.z);

           
        }

        private void Update()
        {
            if (interactable.attachedToHand)
            {
                float pinch = 0;
                pinch = pinchSqueeze.GetAxis(interactable.attachedToHand.handType);
                animator.SetFloat("PushTrigger", pinch);
                if(pinch > 0.5)
                {
                    if (JarScript.hasButterfly == false)
                    {
                        sphereCollider.enabled = true;
                        Debug.Log("collider on" + JarOpen);
                    }               
                    else if (JarScript.hasButterfly == true)
                    {
                        if(pressOnce == false)
                        {
                            sphereCollider.enabled = false;
                            currentCoroutine = StartCoroutine(Delay());
                            Debug.Log("Delay start once");
                            pressOnce = true;
                        }
                    }
                    //JarOpen = true;
                       
                }
                else{
                    sphereCollider.enabled = false;
                    JarOpen = false;
                    if(pressOnce == true)
                    {
                        StopCoroutine(currentCoroutine);
                        Debug.Log("Stop Delay Coroutine");
                        pressOnce = false;
                    }
                }
            }else
            {
                animator.SetFloat("PushTrigger", 0);
            }
        }

       
           
        
         IEnumerator Delay()
            {
                Debug.Log("Start Delay Coroutine");
                yield return new WaitForSeconds(2);

                JarScript.ButterflyinJar.gameObject.transform.parent.DOMove(ExitVector3, 1, false);

                JarScript.ButterflyinJar.transform.parent.SetParent(null);

                butterflyBehaviorTree = JarScript.ButterflyinJar.GetComponent<BehaviorTree>();
                JarScript.ButterflyinJar.GetComponentInParent<NavMeshAgent>().enabled = true;
                JarScript.ButterflyinJar.AddComponent<Rigidbody>();
                JarScript.hasButterfly = false;
                //JarScript.ButterflyinJar.Rigidbody.mass =
                butterflyBehaviorTree.SendEvent<object>("IsFreeJar", false);
            }      
    }
}
