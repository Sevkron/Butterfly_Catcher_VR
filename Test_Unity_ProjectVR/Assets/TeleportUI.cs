using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

namespace Valve.VR.InteractionSystem
{
    public class TeleportUI : MonoBehaviour
{
        private TextMeshProUGUI[] distanceText;
        //private TMP_Text textDistance;
        // Start is called before the first frame update
        void Awake()
        {
            distanceText = GetComponentsInChildren<TextMeshProUGUI>();
        }

        // Update is called once per frame
        void Update()
        {
            float distanceFromPlayer = GetComponentInParent<Teleport>().distanceFromPlayer;
            distanceText[0].text = distanceFromPlayer + " meters";
        }
    }
}