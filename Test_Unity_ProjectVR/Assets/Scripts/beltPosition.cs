using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Valve.VR.InteractionSystem
{
    public class beltPosition : MonoBehaviour
    {
        public GameObject m_playerCamera;
        private Transform cameraTransform;
        private Vector3 test;

        public Vector3 offset;
        public float m_beltHeight;
        public Player player;

        void Start()
        {
            cameraTransform = m_playerCamera.transform;
            m_beltHeight = 0.6f;
            
        }
        // Start is called before the first frame updat
        void Update()
        {
            Vector3 directionPlayer = new Vector3(player.endForward.x, transform.position.y, player.endForward.z);
            transform.LookAt(directionPlayer);
            transform.position = new Vector3(player.hmdTransform.position.x, player.hmdTransform.position.y - m_beltHeight, player.hmdTransform.position.z);
            Debug.Log(player.eyeHeight);
            


            // Vector3 relativePos = cameraTransform.position - transform.position;
            // Quaternion rotation = Quaternion.LookRotation(new Vector3(relativePos.x, 0, relativePos.z), Vector3.up);
            // Vector3 position = new Vector3(transform.position.x, cameraTransform.position.y - m_beltHeight, transform.position.z);
            // transform.rotation = rotation;
            // transform.position = position;

    //Rotation
            //Vector3 lookDir = new Vector3(m_playerCamera.transform.forward.x, transform.position.y, m_playerCamera.transform.forward.z);
            //transform.LookAt(lookDir);
            //transform.position = new Vector3(m_playerCamera.transform.position.x, m_playerCamera.transform.position.y - m_beltHeight, m_playerCamera.transform.position.z) + offset;
        }
    }
}
