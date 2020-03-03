using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;

namespace Valve.VR.InteractionSystem
{
    public class TeleportNoiseDistance : MonoBehaviour
    {
        public float radiusNoise = 10f;
        private RaycastHit[] hits;
        public GameObject[] butterflyGO;
        public Teleport teleportScript;
        private Vector3 noiseSphereScale;

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
            noiseSphereScale = new Vector3(teleportScript.distanceFromPlayer, teleportScript.distanceFromPlayer, teleportScript.distanceFromPlayer)*2;
            transform.localScale = noiseSphereScale;
        }
        public void NoiseTriggerEvent()
        {
            hits = Physics.SphereCastAll(transform.position, radiusNoise, transform.forward);
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
