using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using System;
using UnityEngine.UI;
using Valve.VR.InteractionSystem;

public class PapillodexUIButton : MonoBehaviour
{
        //public GameObject[] m_Panels;
        //---------------------------------------
        public CaughtIndexPanel m_ButterflyIndex;
        //---------------------------------------
        public GameObject m_CaughtIndexPanel;
        public GameObject m_ReproductionIndexPanel;
        //---------------------------------------
        //Add other butterflyPanels here
        public GameObject m_CabbagePanel;
        public GameObject m_DragonTailedPanel;
        public GameObject m_JSMPanel;
        public GameObject m_EmeraldPanel;
        public GameObject m_SaphoPanel;
        public GameObject m_SouthernPanel;
        public GameObject m_DysphaniaPanel;
        public GameObject m_MonarchPanel;
        public GameObject m_CeylonRosePanel;
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
        private Animator canvasAnimator;
        private bool isInIndex = false;
        //public GameObject m_PreviousPanel;
        void Awake()
        {
            m_PreviousPanel = m_MainMenuPanel;
            m_CurrentPanel = m_MainMenuPanel;
            audioManager = FindObjectOfType<AudioManager>();
            canvasAnimator = GetComponent<Animator>();
            m_ButterflyIndex = Player.instance.GetComponent<CaughtIndexPanel>();
        }
        void OnEnable()
        {
            m_CurrentPanel = m_MainMenuPanel;
        }
        public void OnButtonDownHome(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonReturn");
            canvasAnimator.SetTrigger("BackToMain");
            /*m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(false);
            m_MainMenuPanel.SetActive(true);*/
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

        //BAck function unused
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
            canvasAnimator.SetTrigger("OpenIndex");
            m_ButterflyIndex.UpdateButterflyIndexUI();
            /*m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(true);
            m_CaughtIndexPanel.SetActive(true);*/
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_CaughtIndexPanel;

        }

        public void OnButtonDownReproductionIndex(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            canvasAnimator.SetTrigger("CloseButterflyInfo");
            /*m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(true);
            m_ReproductionIndexPanel.SetActive(true);*/
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_ReproductionIndexPanel;
        }
//---------------------------------------
        public void OnButtonDownCompletedMissions(Hand fromHand)
        {
            /*Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(true);
            m_CompletedMissionsPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_CompletedMissionsPanel;*/
        }

        public void OnButtonDownCurrentMissions(Hand fromHand)
        {
            /*Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(true);
            m_CurrentMissionsPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_CurrentMissionsPanel;*/
        }

        public void OnButtonDownButterflyProgression(Hand fromHand)
        {
            /*Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(true);
            m_ButterflyProgressionPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_ButterflyProgressionPanel;*/
        }
//---------------------------------------
        public void OnButtonDownVivarium(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            canvasAnimator.SetTrigger("OpenBaseTP");
            
            /*m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(true);
            m_VivariumPanel.SetActive(true);*/
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_VivariumPanel;
        }

        public void OnButtonConfirmTP(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            //Debug.Log("Confirmed TP");
            canvasAnimator.SetTrigger("OpenBaseTP");
            //OnButtonDownHome(fromHand);
            Teleport.instance.TeleportToBase();
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_MainMenuPanel;
        }
//---------------------------------------
        public void OnButtonDownButterflyInventory(Hand fromHand)
        {
            /*Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(true);
            m_ButterflyInventoryPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_ButterflyInventoryPanel;*/
        }

        public void OnButtonDownOtherInventory(Hand fromHand)
        {
            /*Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            m_CurrentPanel.SetActive(false);
            m_ClockOtherPanel.SetActive(true);
            m_OtherInventoryPanel.SetActive(true);
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_OtherInventoryPanel;*/
        }
//---------------------------------------
        public void OpenCabbageIndex(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            canvasAnimator.SetTrigger("Cabbage");
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_CabbagePanel;
        }
        public void OpenDysphaniaIndex(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            canvasAnimator.SetTrigger("Dysphania");
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_DysphaniaPanel;
        }
        public void OpenEmeraldIndex(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            canvasAnimator.SetTrigger("Emerald");
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_EmeraldPanel;
        }
        public void OpenMonarchIndex(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            canvasAnimator.SetTrigger("Monarch");
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_MonarchPanel;
        }
        public void OpenSaphoIndex(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            canvasAnimator.SetTrigger("Sapho");
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_SaphoPanel;
        }
        public void OpenCeylonIndex(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            canvasAnimator.SetTrigger("Ceylon");
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_CeylonRosePanel;
        }
        public void OpenSouthBirdwingIndex(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            canvasAnimator.SetTrigger("SouthBirdwing");
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_SouthernPanel;
        }
        public void OpenDragonTailedIndex(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            canvasAnimator.SetTrigger("DragonTailed");
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_DragonTailedPanel;
        }
        public void OpenJSMIndex(Hand fromHand)
        {
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            canvasAnimator.SetTrigger("JSM");
            m_PreviousPanel = m_CurrentPanel;
            m_CurrentPanel = m_JSMPanel;
        }

        public void ToggleInfo(Hand fromHand){
            Feedback(fromHand);
            SoundFeedback("CanvasButtonClick");
            canvasAnimator.SetTrigger("CloseButterflyInfo");
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
            fromHand.TriggerHapticPulse(1000);
            fromHand.otherHand.useControllerHoverComponent = false;
            //Debug.Log("Time for haptics Pressed");
        }

        public void SoundFeedback(string sound)
        {
            audioManager.Play(sound, null);
        }

        public void DeactivationPapillodex(){
            this.gameObject.SetActive(false);
        }
    }