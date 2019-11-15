using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using System;

namespace Valve.VR.InteractionSystem.Sample
{
    public class ButtonPapillodex : MonoBehaviour
    {
        public Canvas m_PapillodexCanvas;
        private bool CanvasOpen = false;
        public void OnButtonDown(Hand fromHand)
        {
            fromHand.TriggerHapticPulse(1000);
            CanvasOpen = !CanvasOpen;
            Debug.Log("Pressed");

            if(CanvasOpen == true)
            {
                m_PapillodexCanvas.enabled = true;
            }
            else
            {
                m_PapillodexCanvas.enabled = false;
            }
        }

        public void OnButtonUp(Hand fromHand)
        {

        }
    }
}