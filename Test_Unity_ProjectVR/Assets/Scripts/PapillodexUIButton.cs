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
        public GameObject[] m_Panels;
        public GameObject m_CaughtIndexPanel;
        public GameObject m_ReproductionIndexPanel;
//---------------------------------------
        public GameObject m_CompletedMissionsPanel;
        public GameObject m_CurrentMissionsPanel;
        public GameObject m_ButterflyProgressionPanel;
//---------------------------------------
        public GameObject m_ButterflyInventoryPanel;
        public GameObject m_OtherInventoryPanel;
//---------------------------------------
        public GameObject m_VivariumStatsPanel;
//---------------------------------------
        public GameObject m_MainMenuPanel;
        public GameObject m_CurrentPanel;
        public GameObject m_PreviousPanel;
        //public GameObject m_PreviousPanel;
        void Awake()
        {
            m_PreviousPanel = m_MainMenuPanel;
            m_CurrentPanel = m_MainMenuPanel;
        }
        void OnEnable()
        {
            m_CurrentPanel.SetActive(false);
            m_CurrentPanel = m_MainMenuPanel;
            m_CurrentPanel.SetActive(true);
        }
        public void OnButtonDownHome(Hand fromHand)
        {
            Feedback(fromHand);
            m_CurrentPanel.SetActive(false);
            m_MainMenuPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_MainMenuPanel;
        }

        public void OnButtonDownBack(Hand fromHand)
        {
            Feedback(fromHand);
            m_CurrentPanel.SetActive(false);
            m_PreviousPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_PreviousPanel;
        }
//---------------------------------------
        public void OnButtonDownCaughtIndex(Hand fromHand)
        {
            Feedback(fromHand);
            m_CurrentPanel.SetActive(false);
            m_CaughtIndexPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_CaughtIndexPanel;
        }

        public void OnButtonDownReproductionIndex(Hand fromHand)
        {
            Feedback(fromHand);
            m_CurrentPanel.SetActive(false);
            m_ReproductionIndexPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_ReproductionIndexPanel;
        }
//---------------------------------------
        public void OnButtonDownCompletedMissions(Hand fromHand)
        {
            Feedback(fromHand);
            m_CurrentPanel.SetActive(false);
            m_CompletedMissionsPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_CompletedMissionsPanel;
        }

        public void OnButtonDownCurrentMissions(Hand fromHand)
        {
            Feedback(fromHand);
            m_CurrentPanel.SetActive(false);
            m_CurrentMissionsPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_CurrentMissionsPanel;
        }

        public void OnButtonDownButterflyProgression(Hand fromHand)
        {
            Feedback(fromHand);
            m_CurrentPanel.SetActive(false);
            m_ButterflyProgressionPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_ButterflyProgressionPanel;
        }
//---------------------------------------
        public void OnButtonDownVivariumStats(Hand fromHand)
        {
            Feedback(fromHand);
            m_CurrentPanel.SetActive(false);
            m_VivariumStatsPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_VivariumStatsPanel;
        }
//---------------------------------------
        public void OnButtonDownButterflyInventory(Hand fromHand)
        {
            Feedback(fromHand);
            m_CurrentPanel.SetActive(false);
            m_ButterflyInventoryPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_ButterflyInventoryPanel;
        }

        public void OnButtonDownOtherInventory(Hand fromHand)
        {
            Feedback(fromHand);
            m_CurrentPanel.SetActive(false);
            m_OtherInventoryPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_OtherInventoryPanel;
        }
//---------------------------------------
        public void Feedback(Hand fromHand)
        {
            fromHand.TriggerHapticPulse(1000);
            fromHand.otherHand.useControllerHoverComponent = false;
            Debug.Log("Pressed");
        }
    }
}