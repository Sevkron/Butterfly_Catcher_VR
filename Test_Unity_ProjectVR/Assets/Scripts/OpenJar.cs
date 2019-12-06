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
        //public new SkinnedMeshRenderer renderer;

        public Animator animator;

        public GameObject triggerCollider;

        public bool affectMaterial = false;

        public SteamVR_Action_Single gripSqueeze = SteamVR_Input.GetAction<SteamVR_Action_Single>("SqueezeTrigger");

        public SteamVR_Action_Single pinchSqueeze = SteamVR_Input.GetAction<SteamVR_Action_Single>("SqueezeTrigger");


        private new Rigidbody rigidbody;

        private void Start()
        {
            if (rigidbody == null)
                rigidbody = GetComponent<Rigidbody>();

            if (interactable == null)
                interactable = GetComponent<Interactable>();

            if (animator == null)
                animator = GetComponentInChildren<Animator>();

            //if (renderer == null)
              //  renderer = GetComponent<SkinnedMeshRenderer>();
        }

        private void Update()
        {
            float grip = 0;
            float pinch = 0;

            if (interactable.attachedToHand)
            {
                grip = gripSqueeze.GetAxis(interactable.attachedToHand.handType);
                pinch = pinchSqueeze.GetAxis(interactable.attachedToHand.handType);
                animator.SetFloat("PushTrigger", pinch);
                if(pinch > 0.5){
                    triggerCollider.SetActive(true);
                }else{
                    triggerCollider.SetActive(false);
                }
            }else
            {
                animator.SetFloat("PushTrigger", 0);
            }
        }
    }
}
