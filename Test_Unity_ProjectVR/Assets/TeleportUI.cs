using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

namespace Valve.VR.InteractionSystem
{
    public class TeleportUI : MonoBehaviour
{
        private TextMeshPro distanceText;
        // Start is called before the first frame update
        void Start()
        {
        
        }

        // Update is called once per frame
        void Update()
        {
            float distanceFromPlayer = GetComponentInParent<Teleport>().distanceFromPlayer;
        }
    }
}