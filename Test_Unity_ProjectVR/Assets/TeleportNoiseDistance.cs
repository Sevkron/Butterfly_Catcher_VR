﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;

namespace Valve.VR.InteractionSystem
{
    public class TeleportNoiseDistance : MonoBehaviour
    {
        //public float radiusNoise = 10f;
        private RaycastHit[] hits;
        public GameObject[] butterflyGO;
        public Teleport teleportScript;
        private Vector3 noiseCylinderScale;
        private bool noiseActivate = false;
        void Start()
        {
            if(teleportScript == null)
            {
                teleportScript = transform.parent.transform.parent.GetComponent<Teleport>();
            }
        }
        void Update()
        {
            //distance
            noiseCylinderScale = new Vector3(teleportScript.distanceFromPlayer, 3f, teleportScript.distanceFromPlayer);
            transform.localScale = noiseCylinderScale;
            Gizmos.color = new Color(1, 0, 0, 0.5f);
            if(teleportScript.teleporting == true)
            {
                NoiseTriggerEvent(teleportScript.distanceFromPlayer);
                Debug.Log("Activate Noise trigger event");
            }
        }
        public void NoiseTriggerEvent(float radiusNoise)
        {
            Vector3 p1 = transform.position + new Vector3(0, 0.78f, 0) + Vector3.up * -3f * 0.5f;
            Vector3 p2 = p1 + Vector3.up * 3f;
            hits = Physics.CapsuleCastAll(p1, p2, radiusNoise, transform.forward);
            int f = 0;
            for(int i = 0; i < hits.Length; i++)
            {
                if(hits[i].transform.gameObject.CompareTag("Butterfly") == true)
                {
                    butterflyGO[f] = hits[i].transform.gameObject;
                    butterflyGO[f].transform.parent.GetComponent<BehaviorTree>().SendEvent("hasHeardTP");
                    f++;
                }
            }
        }
    }
}
