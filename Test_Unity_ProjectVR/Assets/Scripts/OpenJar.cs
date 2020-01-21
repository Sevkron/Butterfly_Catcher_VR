using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using Valve.VR;
using Valve.VR.InteractionSystem;

namespace Valve.VR.InteractionSystem.Sample
{
    public class OpenJar : MonoBehaviour
    {
        public Interactable interactable;

        public Animator animator;
         
        public SphereCollider sphereCollider; 

        public bool affectMaterial = false;

        public bool JarOpen;

        public bool hasButterfly;

        //public SteamVR_Action_Single gripSqueeze = SteamVR_Input.GetAction<SteamVR_Action_Single>("SqueezeTrigger");

        public SteamVR_Action_Single pinchSqueeze = SteamVR_Input.GetAction<SteamVR_Action_Single>("SqueezeTrigger");

        private void Start()
        {
            if (interactable == null)
                interactable = GetComponent<Interactable>();

            if (animator == null)
                animator = GetComponentInChildren<Animator>();
        }

        private void Update()
        {
            if (interactable.attachedToHand)
            {
                float pinch = 0;
                pinch = pinchSqueeze.GetAxis(interactable.attachedToHand.handType);
                animator.SetFloat("PushTrigger", pinch);
                if(pinch > 0.5){
                    if (hasButterfly == false)
                    {
                        sphereCollider.enabled = true;
                         JarOpen = true;
                    }               
                    else if (hasButterfly == true)
                    {
                        sphereCollider.enabled = false;
                        JarOpen = true;
                    }
                       
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

        public void JarUpdate(bool hasButterfly, BehaviorTree butterflyBehavior)
        {

        }
    }
}
