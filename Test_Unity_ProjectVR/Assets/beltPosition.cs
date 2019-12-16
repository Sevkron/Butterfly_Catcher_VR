using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class beltPosition : MonoBehaviour
{
    public GameObject m_playerCamera;
    private Transform cameraTransform;
    private Vector3 test;

    void Start()
    {
        cameraTransform = m_playerCamera.transform;
        test = new Vector3(0, m_playerCamera.transform.position.y, 0);
    }
    // Start is called before the first frame updat
    void Update()
    {
        Vector3 relativePos = cameraTransform.position - transform.position;
        Quaternion rotation = Quaternion.LookRotation(new Vector3(relativePos.x, 0, relativePos.z), Vector3.up);
        transform.rotation = rotation; 
    }
}
