using System.Collections;
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
        private YMovement YMovement;



        public SteamVR_Action_Single pinchSqueeze = SteamVR_Input.GetAction<SteamVR_Action_Single>("SqueezeTrigger");

        private void Awake()
        {
            if (interactable == null)
                interactable = GetComponent<Interactable>();

            if (animator == null)
                animator = GetComponentInChildren<Animator>();

            JarScript = GetComponentInChildren<ButterflyJar>();


            ExitVector3 = new Vector3(ExitPoint.transform.position.x, ExitPoint.transform.position.y, ExitPoint.transform.position.z);

        }

        private void Update()
        {
            ButterflyCatched();
            OpeningJar();
        }

        public void OpeningJar()
        {
            if (interactable.attachedToHand)
            {
                float pinch = 0;
                pinch = pinchSqueeze.GetAxis(interactable.attachedToHand.handType);
                animator.SetFloat("PushTrigger", pinch);
                if (pinch > 0.5)
                {
                    JarOpen = true;
                    if (JarScript.hasButterfly == false)
                    {
                        sphereCollider.enabled = true;
                        Debug.Log("collider on" + JarOpen);
                    }
                    else if (JarScript.Butterflycatched == true)
                    {
                        if (pressOnce == false)
                        {
                            sphereCollider.enabled = false;

                            JarScript.FreeButterfly();
                            Debug.Log("Delay start once");
                            pressOnce = true;
                        }
                    }


                }
                else
                {
                    sphereCollider.enabled = false;
                    JarOpen = false;
                    if (pressOnce == true)
                    {
                        JarScript.StopCoroutine();
                        Debug.Log("Stop Delay Coroutine");
                        pressOnce = false;
                    }
                }
            }
            else
            {
                animator.SetFloat("PushTrigger", 0);
            }
        }

        public void ButterflyCatched()
        {
            if (JarScript.hasButterfly == true && JarOpen == false)
            {
                JarScript.Butterflycatched = true;
            }
        }
    }
}
