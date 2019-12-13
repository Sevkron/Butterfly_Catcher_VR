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
        public Hand leftHand;
        public Hand rightHand;

        void Awake()
        {
            if(leftHand == null || rightHand == null)
            {
                Debug.Log("Setup Hands");
            }
        }
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
                leftHand.useHoverSphere = false;
                rightHand.useHoverSphere = false;
            }
            else
            {
                FindObjectOfType<AudioManager>().Play("ClickButtonPapillodex");
                FindObjectOfType<AudioManager>().Play("CanvasDeactivate");
                m_Papillodex.SetActive(false);
                leftHand.useHoverSphere = true;
                rightHand.useHoverSphere = true;
            }
        }

        public void OnButtonUp(Hand fromHand)
        {

        }
    }
}