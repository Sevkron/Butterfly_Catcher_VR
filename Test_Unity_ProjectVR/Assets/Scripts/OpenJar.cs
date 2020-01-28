using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using Valve.VR;
using Valve.VR.InteractionSystem;
using UnityEngine.AI;

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
                if(pinch > 0.5){

                    if (JarScript.hasButterfly == false)
                    {
                        sphereCollider.enabled = true;
                        Debug.Log("collider on" + JarOpen);
                    }               
                    else if (JarScript.hasButterfly == true)
                    {
                        sphereCollider.enabled = false;
                    }
                    JarOpen = true;
                    JarUpdate();
                }
                else{
                    sphereCollider.enabled = false;
                    JarOpen = false;
                }
            }else
            {
                animator.SetFloat("PushTrigger", 0);
            }
        }

        public void JarUpdate(bool hasButterfly, BehaviorTree butterflyBehavior, bool Jaropen)
        {
            if (JarOpen == true & hasButterfly == true )
            {
                //& wait for 3sec then:

                //translate butterfly out of the jar
                JarScript.ButterflyinJar.transform.Translate(ExitVector3 * Time.deltaTime);

                butterflyBehaviorTree = JarScript.ButterflyinJar.GetComponent<BehaviorTree>();
                JarScript.ButterflyinJar.GetComponent<NavMeshAgent>().enabled = true;
                //Destroy(other.gameObject.GetComponent<Rigidbody>());
                butterflyBehaviorTree.SendEvent<object>("IsFreeJar", JarScript.ButterflyinJar);

            }
        }
    }
}
