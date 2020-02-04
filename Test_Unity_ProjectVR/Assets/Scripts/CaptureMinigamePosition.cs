using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CaptureMinigamePosition : MonoBehaviour
{
 [Range(0.5f, 0.75f)]
    public float height = 0.5f;

 [Range(0.5f, 5.0f)]
    public float distance = 2f;

    private Transform head = null;
    public GameObject m_playercamera;

    void Start()
    {
        head = m_playercamera.transform;  
    }

    // Update is called once per frame
    void Update()
    {
        PositionUnderHead();
        RotateWithHead();
    }

    private void PositionUnderHead()
    {
        Vector3 adjustedHeight = head.localPosition;
        adjustedHeight.y = Mathf.Lerp(0.0f, adjustedHeight.y, height);
        adjustedHeight.z = Mathf.Lerp(adjustedHeight.z, distance, height);

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
