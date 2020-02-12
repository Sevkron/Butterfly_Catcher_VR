using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Valve.VR.InteractionSystem
{
    public class DirectMovement : MonoBehaviour
    {
        public SteamVR_Action_Boolean teleportAction = SteamVR_Input.GetAction<SteamVR_Action_Boolean>("Teleport");
        public SteamVR_Action_Boolean switchMoveTypeAction = SteamVR_Input.GetAction<SteamVR_Action_Boolean>("SwitchMovementModes");

        private Hand pointerHand = null;
        private Player player = null;
        public GameObject teleportGO;

        public AudioSource directMoveSource;
        public AudioClip directMoveSound;
        void Start()
        {
            player = InteractionSystem.Player.instance;

			if ( player == null )
			{
				Debug.LogError("<b>[SteamVR Interaction]</b> Teleport: No Player instance found in map.", this);
				Destroy( this.gameObject );
				return;
			}


        }

    // Update is called once per frame
        void Update()
        {
            Hand oldPointerHand = pointerHand;
			Hand newPointerHand = null;

			foreach ( Hand hand in player.hands )
			{
				if ( wasSwitchMovePressed() )
				{
					if ( pointerHand == hand ) //This is the pointer hand
					{
						MovePlayer(hand);
					}
				}
				
				if ( wasSwitchMovePressed() )
				{
					Debug.Log("Pressed switch move");
					newPointerHand = hand;
					
				}
			}

            bool leftHandSwitchMode = switchMoveTypeAction.GetStateDown(SteamVR_Input_Sources.LeftHand);
            bool rightHandSwitchMode = switchMoveTypeAction.GetStateDown(SteamVR_Input_Sources.RightHand);

            if (leftHandSwitchMode || rightHandSwitchMode)
                {
                    wasSwitchMovePressed();
                }
        }

        private bool wasSwitchMovePressed()
        {
            return true;
        }

        private void MovePlayer(Hand hand)
        {

        }
    }
}
