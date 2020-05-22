
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using Valve.VR.InteractionSystem;
public class TeleportUI : MonoBehaviour
{
        public TextMeshProUGUI[] distanceText;
        public GameObject teleportGO;
        public Teleport teleportScript;
        public Camera m_Camera;
        private Hand tpHand;
        private GameObject CameraGO;
        //private TMP_Text textDistance;
        // Start is called before the first frame update
        void Awake()
        {
            if(distanceText == null)
                distanceText = GetComponentsInChildren<TextMeshProUGUI>();

            if(teleportScript == null)
            {
                teleportGO = GameObject.Find("Teleporting");
                teleportScript = teleportGO.GetComponent<Teleport>();
            }

            if(m_Camera == null)
            {
                CameraGO = GameObject.FindGameObjectWithTag("MainCamera");
                m_Camera = CameraGO.GetComponent<Camera>();
            }
        }

        // Update is called once per frame
        void Update()
        {
            if(teleportScript == null)
            {
                teleportGO = GameObject.Find("Teleporting");
                teleportScript = teleportGO.GetComponent<Teleport>();
            }
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