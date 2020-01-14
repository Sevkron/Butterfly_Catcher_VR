using System.Collections;
using System.Collections.Generic;
using UnityEngine;
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
                    sphereCollider.enabled = true;
                }else{
                    sphereCollider.enabled = false;
                }
            }else
            {
                animator.SetFloat("PushTrigger", 0);
            }
        }
    }
}
