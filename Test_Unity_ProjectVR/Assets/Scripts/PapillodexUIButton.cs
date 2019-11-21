using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using System;
using UnityEngine.UI;

namespace Valve.VR.InteractionSystem.Sample
{
public class PapillodexUIButton : MonoBehaviour
{
        public GameObject m_IndexPanel;
        public GameObject m_MainMenuPanel;
        public GameObject m_PreviousPanel;
        public void OnButtonDown(Hand fromHand)
        {
            fromHand.TriggerHapticPulse(1000);
            fromHand.otherHand.useControllerHoverComponent = false;
            Debug.Log("Pressed");
            m_IndexPanel.SetActive(true);
            this.gameObject.SetActive(false);
        }

        public void OnButtonUp(Hand fromHand)
        {

        }
    }
}