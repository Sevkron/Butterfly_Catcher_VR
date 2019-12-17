using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class beltPosition : MonoBehaviour
{
    public GameObject m_playerCamera;
    private Transform cameraTransform;
    private Vector3 test;

    public Vector3 offset;
    public float m_beltHeight;

    void Start()
    {
        cameraTransform = m_playerCamera.transform;
        m_beltHeight = transform.position.y;
    }
    // Start is called before the first frame updat
    void Update()
    {
        // Vector3 relativePos = cameraTransform.position - transform.position;
        // Quaternion rotation = Quaternion.LookRotation(new Vector3(relativePos.x, 0, relativePos.z), Vector3.up);
        // Vector3 position = new Vector3(transform.position.x, cameraTransform.position.y - m_beltHeight, transform.position.z);
        // transform.rotation = rotation;
        // transform.position = position;

//Rotation
        Vector3 lookDir = new Vector3(m_playerCamera.transform.forward.x, transform.position.y, m_playerCamera.transform.forward.z);
        transform.LookAt(lookDir);
        transform.position = new Vector3(m_playerCamera.transform.position.x, m_playerCamera.transform.position.y - m_beltHeight, m_playerCamera.transform.position.z) + offset;
    }
}
