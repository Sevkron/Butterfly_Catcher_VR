using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;
using Valve.VR.InteractionSystem;

public class DirectMovement : MonoBehaviour
{
    public SteamVR_Action_Boolean teleportAction = SteamVR_Input.GetAction<SteamVR_Action_Boolean>("Teleport");
    public SteamVR_Action_Boolean switchMoveTypeAction = SteamVR_Input.GetAction<SteamVR_Action_Boolean>("SwitchMovementModes");

    private Hand pointerHand = null;
    private Player player = null;
    public GameObject teleportGO;

    public AudioSource directMoveSource;
    public AudioClip directMoveSound;

    private CharacterController characterController;
    public float speed = 1;    
    void Start()
    {
        player = InteractionSystem.Player.instance;
        characterController = GetComponent<CharacterController>();

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

        Vector3 direction = Player.instance.hmdTransform.TransformDirection(new Vector3(Input.axis.x, 0, Input.axis.y));
        characterController.Move(speed * Time.deltaTime * Vector3.ProjectOnPlane(direction,Vector3.up));
    }

    private bool wasSwitchMovePressed()
    {
        return true;
    }

    private void MovePlayer(Hand hand)
    {

    }
}

