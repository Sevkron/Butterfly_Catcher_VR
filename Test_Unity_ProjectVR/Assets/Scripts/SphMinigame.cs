using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class SphMinigame : MonoBehaviour
{
    public SphereInt[] sphMinigame;
    public float timer;
    private int i = 0;
    private List<string> SoundsToPlay;
    private string butterflyType;

    [HideInInspector] 
    private CaptureMinigamePool m_captureMinigamePool;

    void Start()
    {
        
    }   
    void OnEnable()
    {   
        if(m_captureMinigamePool == null)
            m_captureMinigamePool = GameObject.Find("CaptureMinigamePool").GetComponent<CaptureMinigamePool>();

        m_captureMinigamePool.m_CountdownCanvas.SetActive(true);
        StartCoroutine(WaitForAnimation());
        
        butterflyType = m_captureMinigamePool.currentButterfly.GetComponent<YMovement>().stringButterflySpecies;
        
        if(butterflyType == "Dragon_Tail")
        {
            SoundsToPlay = new List<string>(){"DragonTailsNote1","DragonTailsNote2","DragonTailsNote3"};
            Debug.Log("You Got a Dragon tail");
        }else if(butterflyType == "Cabbage_White_Butterfly")
        {
            SoundsToPlay = new List<string>(){"CabbageWhiteNote1","CabbageWhiteNote2","CabbageWhiteNote3"};
        }else if(butterflyType == "Sapho_Longwing")
        {
            SoundsToPlay = new List<string>(){"CabbageWhiteNote1","CabbageWhiteNote2","CabbageWhiteNote3"};
        }else if(butterflyType == "Japanese_Silk_Moth")
        {
            SoundsToPlay = new List<string>(){"JapaneseSilkNote1","JapaneseSilkNote2","JapaneseSilkNote3"};
        }else if(butterflyType == "Ceylon_Rose")
        {
            SoundsToPlay = new List<string>(){"CeylonRose1","CeylonRose2","CeylonRose3","CeylonRose4","CeylonRose5","CeylonRose6"};
        }else if(butterflyType == "Dysphania_Militaris_Moth")
        {
            SoundsToPlay = new List<string>(){"DysphaniaMillitarisNote1","DysphaniaMillitarisNote2","DysphaniaMillitarisNote3","DysphaniaMillitarisNote4"};
        }else if(butterflyType == "Emerald_Swallowtail" || butterflyType == "Monarch")
        {
            SoundsToPlay = new List<string>(){"EmeraldSwallowtailNote1","EmeraldSwallowtailNote2","EmeraldSwallowtailNote3","EmeraldSwallowtailNote4"};
        }else if(butterflyType == "Southern_Birdwing")
        {
            SoundsToPlay = new List<string>(){"SouthernBirfwingNote1","SouthernBirfwingNote2","SouthernBirfwingNote3"};
        }else{
            SoundsToPlay = new List<string>(){"DragonTailsNote1","DragonTailsNote2","DragonTailsNote3"};
            Debug.LogError("Butterfly Not Identifies");
        }
        //Debug.Log("Started this thing");
    }

    public void MinigameFail()
    {
        m_captureMinigamePool.PlaySound("CaptureFail");
        m_captureMinigamePool.FreeButterfly();
        Destroy(this.gameObject);
    }

    public void CaughtSuccess()
    {
        m_captureMinigamePool.PlaySound(SoundsToPlay[i]);
        i = i + 1;
        //Debug.Log("Array is of length : " + sphMinigame.Length);
        //Debug.Log("i is equal to : " + i);

        if(i == sphMinigame.Length - 1)
        {
            sphMinigame[i].StartTimer(timer, true);
            Debug.Log("Start final sphere");
            
        }else if(i < sphMinigame.Length - 1)
        {
            sphMinigame[i].StartTimer(timer, false);
            Debug.Log("Caught sphere success");
        }
        else
        {
            m_captureMinigamePool.CaughtButterfly();
            Debug.Log("That was the final sphere");
            Destroy(this.gameObject);
        }
    }

    private IEnumerator WaitForAnimation()
    {
        yield return new WaitForSeconds(3f);
        m_captureMinigamePool.m_CountdownCanvas.SetActive(false);
        i = 0;
        sphMinigame[i].StartTimer(timer, false);
    }
}
