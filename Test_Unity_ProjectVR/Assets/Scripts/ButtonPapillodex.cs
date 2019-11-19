using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using System;

namespace Valve.VR.InteractionSystem.Sample
{
    public class ButtonPapillodex : MonoBehaviour
    {
        private Canvas m_PapillodexCanvas;
        public GameObject m_Papillodex;
        private bool CanvasOpen = false;
        public void OnButtonDown(Hand fromHand)
        {
            fromHand.TriggerHapticPulse(1000);
            CanvasOpen = !CanvasOpen;
            Debug.Log("Pressed");

            if(CanvasOpen == true)
            {
                m_Papillodex.SetActive(true);
            }
            else
            {
                m_Papillodex.SetActive(false);
            }
        }

        public void OnButtonUp(Hand fromHand)
        {

        }
    }
}