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
        private AudioSource audioSource;
        public void OnButtonDown(Hand fromHand)
        {
            fromHand.TriggerHapticPulse(1000);
            fromHand.otherHand.useControllerHoverComponent = false;
            CanvasOpen = !CanvasOpen;
            Debug.Log("Pressed");

            if(CanvasOpen == true)
            {
                m_Papillodex.SetActive(true);
                FindObjectOfType<AudioManager>().Play("ClickButtonPapillodex");
                FindObjectOfType<AudioManager>().Play("CanvasActivate");
            }
            else
            {
                FindObjectOfType<AudioManager>().Play("ClickButtonPapillodex");
                FindObjectOfType<AudioManager>().Play("CanvasDeactivate");
                m_Papillodex.SetActive(false);
            }
        }

        public void OnButtonUp(Hand fromHand)
        {

        }
    }
}