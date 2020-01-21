using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

namespace Valve.VR.InteractionSystem
{
    public class TeleportUI : MonoBehaviour
{
        private TextMeshProUGUI[] distanceText;
        private GameObject teleportGO;
        private Teleport teleportScript;
        public Camera m_Camera;
        private GameObject CameraGO;
        //private TMP_Text textDistance;
        // Start is called before the first frame update
        void Awake()
        {
            distanceText = GetComponentsInChildren<TextMeshProUGUI>();
            teleportGO = GameObject.Find("Teleporting");
            teleportScript = teleportGO.GetComponent<Teleport>();
            CameraGO = GameObject.FindGameObjectWithTag("MainCamera");
            m_Camera = CameraGO.GetComponent<Camera>();
        }

        // Update is called once per frame
        void Update()
        {
            //if(GetComponentInParent<Hand>().in)
            float distanceFromPlayer = teleportScript.distanceFromPlayer;
            if(distanceFromPlayer <= teleportScript.arcDistance)
            {
                distanceText[0].text = Mathf.RoundToInt(distanceFromPlayer) + " m";
            }else
                distanceText[0].text = "0 m";
        }

         void LateUpdate()
        {
            transform.LookAt(transform.position + m_Camera.transform.rotation * Vector3.forward,
            m_Camera.transform.rotation * Vector3.up);
    
        }
    }
}