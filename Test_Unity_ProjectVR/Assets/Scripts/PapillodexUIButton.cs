using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using System;
using UnityEngine.UI;
using Valve.VR.InteractionSystem;

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
        public GameObject m_VivariumPanel;
//---------------------------------------
        public GameObject m_MainMenuPanel;
        public GameObject m_CurrentPanel;
        public GameObject m_PreviousPanel;
        public GameObject m_QuitPanel;
        public GameObject m_OptionsPanel;
        public GameObject m_ClockOtherPanel;
        private AudioManager audioManager;

        private bool isActive = false;
        //public GameObject m_PreviousPanel;
        void Awake()
        {
            m_PreviousPanel = m_MainMenuPanel;
            m_CurrentPanel = m_MainMenuPanel;
            audioManager = FindObjectOfType<AudioManager>();
        }
        void OnEnable()
        {
            if(m_CurrentPanel != m_MainMenuPanel){
                
            }
            m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(false);
            m_CurrentPanel = m_MainMenuPanel;
            m_CurrentPanel.SetActive(true);
        }
        public void OnButtonDownHome(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonReturn");
            m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(false);
            m_MainMenuPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_MainMenuPanel;
        }

        public void OnButtonDownOptions(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(false);
            m_OptionsPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_OptionsPanel;
        }

        public void OnButtonDownBack(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonReturn");
            m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(false);
            m_PreviousPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_PreviousPanel;
        }

        public void OnButtonDownQuit1(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(false);
            m_QuitPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_QuitPanel;
        }

        public void OnButtonDownQuit2(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            Debug.Log("Quitting App");
            Application.Quit();
        }
//---------------------------------------
        public void OnButtonDownCaughtIndex(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(true);
            m_CaughtIndexPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_CaughtIndexPanel;

        }

        public void OnButtonDownReproductionIndex(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(true);
            m_ReproductionIndexPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_ReproductionIndexPanel;
        }
//---------------------------------------
        public void OnButtonDownCompletedMissions(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(true);
            m_CompletedMissionsPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_CompletedMissionsPanel;
        }

        public void OnButtonDownCurrentMissions(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(true);
            m_CurrentMissionsPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_CurrentMissionsPanel;
        }

        public void OnButtonDownButterflyProgression(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(true);
            m_ButterflyProgressionPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_ButterflyProgressionPanel;
        }
//---------------------------------------
        public void OnButtonDownVivarium(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(true);
            m_VivariumPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_VivariumPanel;
        }

        public void OnButtonConfirmTP(Hand fromHand)
        {
            OnButtonDownHome(fromHand);
            Teleport.instance.TeleportToBase();

        }
//---------------------------------------
        public void OnButtonDownButterflyInventory(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(true);
            m_ButterflyInventoryPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_ButterflyInventoryPanel;
        }

        public void OnButtonDownOtherInventory(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(true);
            m_OtherInventoryPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_OtherInventoryPanel;
        }
//---------------------------------------

        public void RecenterCam(Hand fromHand)
        {
            UnityEngine.XR.InputTracking.Recenter();
            Debug.Log("Camera Recentered");
        }
        public void Feedback(Hand fromHand)
        {
            //Reactivate for haptics
            /*fromHand.TriggerHapticPulse(1000);
            fromHand.otherHand.useControllerHoverComponent = false;*/
            Debug.Log("Time for haptics Pressed");
        }

        public void SoundFeedback(string sound)
        {
            audioManager.Play(sound, null);
        }

        public void DeactivationPapillodex(){
            this.gameObject.SetActive(false);
        }
    }