using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;
using Valve.VR.InteractionSystem;

public class Belt : MonoBehaviour
{
    [Range(0.5f, 0.75f)]
    public float height = 0.5f;

    private Transform head = null;
    public GameObject m_playercamera;
    private Player player;

    void Start()
    {
        player = Player.instance;
        head = m_playercamera.transform;  
    }

    // Update is called once per frame
    void Update()
    {
        PositionUnderHead();
        RotateWithHead();
        //if(player.hmdTransform.TransformDirection(new Vector3(0, 0, playerYInput)) = )
    }

    private void PositionUnderHead()
    {
        Vector3 adjustedHeight = head.localPosition;
        adjustedHeight.y = Mathf.Lerp(0.0f, adjustedHeight.y, height);

        transform.localPosition = adjustedHeight;

    }

    private void RotateWithHead()
    {
        Vector3 adjustedRotation = head.localEulerAngles;
        adjustedRotation.x = 0;
        adjustedRotation.z = 0;

        transform.localEulerAngles = adjustedRotation;
    }
}
