using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;
using Valve.VR.InteractionSystem;
using UnityEngine.Rendering.PostProcessing;

public class DirectMovement : MonoBehaviour
{
    public SteamVR_Action_Boolean teleportAction = SteamVR_Input.GetAction<SteamVR_Action_Boolean>("Teleport");
    public SteamVR_Action_Vector2 input;
    public SteamVR_Action_Boolean switchMoveTypeAction = SteamVR_Input.GetAction<SteamVR_Action_Boolean>("SwitchMovementModes");

    private Hand pointerHand = null;
    private Player player;
    //public GameObject teleportGO;

    public AudioSource directMoveSource;
    public AudioClip directMoveSound;

    public PostProcessVolume ppVolume;
    Vignette vignetteLayer = null;

    private CharacterController characterController;
    private float speed = 1;
    private float playerYInput;
    void Start()
    {
        //player = InteractionSystem.Player.instance;
        characterController = GetComponent<CharacterController>();
        if(ppVolume == null)
        {
            Debug.Log("PostProcessVolume = null in directmove Script");
        }
        ppVolume.profile.TryGetSettings(out vignetteLayer);
    }

    void Update()
    {   
        //Move, change to == 0 to allow backwards
        if(input.axis.y > 0)
        {
            playerYInput = input.axis.y;
            VignetteEffect(playerYInput);

            Vector3 direction = Player.instance.hmdTransform.TransformDirection(new Vector3(0, 0, playerYInput));
            characterController.Move(playerYInput * Time.deltaTime * Vector3.ProjectOnPlane(direction, Vector3.up) - new Vector3(0, 9.81f, 0) * Time.deltaTime);
            characterController.center = new Vector3(Player.instance.hmdTransform.localPosition.x, characterController.center.y, Player.instance.hmdTransform.localPosition.z);
        }
    }

    private void VignetteEffect(float vignetteIntensityValue)
    {
        vignetteLayer.intensity.value = vignetteIntensityValue;
    }
}

