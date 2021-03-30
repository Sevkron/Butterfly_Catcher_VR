using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class SphMinigame : MonoBehaviour
{
    public SphereInt[] sphMinigame;
    public List<SphereInt> m_OriginalSpheres;
    public GameObject m_holoButterfly;
    public float timer;
    private int i = 0;
    private List<string> SoundsToPlay;
    private List<SphereInt> RandomizedSpheres;
    private string butterflyType;

    [HideInInspector] 
    private CaptureMinigamePool m_captureMinigamePool;
    Tween MyTween;

    void Start()
    {
        
    }   
    void OnEnable()
    {   
        if(m_captureMinigamePool == null)
            m_captureMinigamePool = GameObject.Find("CaptureMinigamePool").GetComponent<CaptureMinigamePool>();

        m_captureMinigamePool.m_CountdownCanvas.SetActive(true);

        

        StartCoroutine(WaitForCountdown());
        
        butterflyType = m_captureMinigamePool.currentButterfly.GetComponent<YMovement>().GetSpeciesName();

        switch(butterflyType)
        {   
            case "Dragon_Tail":
                SoundsToPlay = new List<string>(){"DragonTailsNote1","DragonTailsNote2","DragonTailsNote3"};
            break;
            case "Cabbage_White_Butterfly":
                SoundsToPlay = new List<string>(){"CabbageWhiteNote1","CabbageWhiteNote2","CabbageWhiteNote3"};
            break;
            case "Sapho_Longwing":
                SoundsToPlay = new List<string>(){"CabbageWhiteNote1","CabbageWhiteNote2","CabbageWhiteNote3"};
            break;
            case "Japanese_Silk_Moth":
                SoundsToPlay = new List<string>(){"JapaneseSilkNote1","JapaneseSilkNote2","JapaneseSilkNote3"};
            break;
            case "Ceylon_Rose":
                SoundsToPlay = new List<string>(){"CeylonRoseNote1","CeylonRoseNote2","CeylonRoseNote3","CeylonRoseNote4","CeylonRoseNote5","CeylonRoseNote6"};
            break;
            case "Dysphania_Militaris_Moth":
                SoundsToPlay = new List<string>(){"DysphaniaMillitarisNote1","DysphaniaMillitarisNote2","DysphaniaMillitarisNote3","DysphaniaMillitarisNote4"};
            break;
            case "Emerald_Swallowtail":
                SoundsToPlay = new List<string>(){"EmeraldSwallowtailNote1","EmeraldSwallowtailNote2","EmeraldSwallowtailNote3","EmeraldSwallowtailNote4"};
            break;
            case "Monarch":
                SoundsToPlay = new List<string>(){"EmeraldSwallowtailNote1","EmeraldSwallowtailNote2","EmeraldSwallowtailNote3","EmeraldSwallowtailNote4"};
            break;
            case "Southern_Birdwing":
                SoundsToPlay = new List<string>(){"SouthernBirfwingNote1","SouthernBirfwingNote2","SouthernBirfwingNote3"};
            break;
            default:
                SoundsToPlay = new List<string>(){"DragonTailsNote1","DragonTailsNote2","DragonTailsNote3"};
                Debug.LogError("Butterfly Not Identified");
            break;
        }
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
        Destroy(RandomizedSpheres[i].gameObject);
        i = i + 1;
        
        //Debug.Log("Array is of length : " + sphMinigame.Length);
        //Debug.Log("i is equal to : " + i);

        if(i == RandomizedSpheres.Count - 1)
        {
            RandomizedSpheres[i].StartTimer(timer, true);
            //MyTween =
            StartCoroutine(WaitForHoloButterfly(RandomizedSpheres[i].gameObject.transform.position));
            Debug.Log("Start final sphere");
            
        }else if(i < RandomizedSpheres.Count - 1)
        {
            RandomizedSpheres[i].StartTimer(timer, false);
            StartCoroutine(WaitForHoloButterfly(RandomizedSpheres[i].gameObject.transform.position));
            //Debug.Log("Caught sphere success");
        }
        else
        {
            m_captureMinigamePool.CaughtButterfly();
            //Debug.Log("That was the final sphere");
            Destroy(this.gameObject);
        }
    }

    private IEnumerator WaitForCountdown()
    {
        int indexLength = m_OriginalSpheres.Count;
        int newIndexLength = indexLength;
        RandomizedSpheres = new List<SphereInt>();
        for(int s = 0; s < indexLength; s++)
        {
            int randomNumber = Random.Range(0, newIndexLength);
            //Debug.Log("Drawing spheres from range " + randomNumber);

            RandomizedSpheres.Add(m_OriginalSpheres[randomNumber]);
            m_OriginalSpheres.RemoveAt(randomNumber);
            
            newIndexLength = newIndexLength - 1;
        }
        yield return new WaitForSeconds(3f);
        m_captureMinigamePool.m_CountdownCanvas.SetActive(false);
        i = 0;
        RandomizedSpheres[i].StartTimer(timer, false);
        //m_holoButterfly.transform.position = sphMinigame[i].gameObject.transform.position;
        MyTween = m_holoButterfly.transform.DOMove(RandomizedSpheres[i].gameObject.transform.position, 0.3f, false);
        m_holoButterfly.transform.DOLookAt(RandomizedSpheres[i].gameObject.transform.position, 0.3f);
    }

    private IEnumerator WaitForHoloButterfly(Vector3 newPos)
    {
        MyTween = m_holoButterfly.transform.DOMove(newPos, 0.3f, false);
        m_holoButterfly.transform.DOLookAt(newPos, 0.3f);
        yield return MyTween.WaitForCompletion();
    }
}
