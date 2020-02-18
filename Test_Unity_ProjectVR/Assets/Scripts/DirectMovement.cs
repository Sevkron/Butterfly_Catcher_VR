using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;
using Valve.VR.InteractionSystem;

public class DirectMovement : MonoBehaviour
{
    public SteamVR_Action_Boolean teleportAction = SteamVR_Input.GetAction<SteamVR_Action_Boolean>("Teleport");

    public SteamVR_Action_Vector2 input;
    public SteamVR_Action_Boolean switchMoveTypeAction = SteamVR_Input.GetAction<SteamVR_Action_Boolean>("SwitchMovementModes");

    private Hand pointerHand = null;
    private Player player = null;
    public GameObject teleportGO;

    public AudioSource directMoveSource;
    public AudioClip directMoveSound;

    private CharacterController characterController;
    public float speed = 1;
    private float forwardAxis;
    void Start()
    {
        //player = InteractionSystem.Player.instance;
        characterController = GetComponent<CharacterController>();
    }

    // Update is called once per frame
    void Update()
    {
        forwardAxis = input.axis.y;
        if(input.axis.y < 0)
        {
            forwardAxis = 0;
        }

        Vector3 direction = Player.instance.hmdTransform.TransformDirection(new Vector3(0, 0, forwardAxis));
        characterController.Move(speed * Time.deltaTime * Vector3.ProjectOnPlane(direction, Vector3.up) - new Vector3(0, 9.81f, 0) * Time.deltaTime);

        bool leftHandSwitchMode = switchMoveTypeAction.GetStateDown(SteamVR_Input_Sources.LeftHand);
        bool rightHandSwitchMode = switchMoveTypeAction.GetStateDown(SteamVR_Input_Sources.RightHand);

        if (leftHandSwitchMode || rightHandSwitchMode)
        {
            wasSwitchMovePressed();
        }

        //Vector3 direction = Player.instance.hmdTransform.TransformDirection(new Vector3(Input.axis.x, 0, Input.axis.y));
        //characterController.Move(speed * Time.deltaTime * Vector3.ProjectOnPlane(direction,Vector3.up));
    }

    private bool wasSwitchMovePressed()
    {
        return true;
    }

    private void MovePlayer(Hand hand)
    {

    }
}

