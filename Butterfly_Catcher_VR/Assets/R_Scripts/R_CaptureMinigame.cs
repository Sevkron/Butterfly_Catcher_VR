using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class R_CaptureMinigame : MonoBehaviour
{   
    public bool isNotInMinigame = true;
    [SerializeField]
    private AudioManager audioManager;
    private List<string> SoundsToPlay;
    [SerializeField]
    private GameObject[] CaptureLevel0;
    [SerializeField]
    private GameObject[] CaptureIcons;
    private GameObject currentActiveChallenge;
    private GameObject currentActiveIcon;
    void Awake()
    {
        if(audioManager == null)
        {
            audioManager = AudioManager.instance;
        }
    }

    public void SpawnChallenge(Transform origin, YMovement butterflyScript)
    {
        isNotInMinigame = false;
        int i = Random.Range(0, CaptureLevel0.Length);
        currentActiveChallenge = Instantiate(CaptureLevel0[i], origin.position, origin.rotation, null);
        currentActiveIcon = Instantiate(CaptureIcons[0], origin.position, origin.rotation, null);
        currentActiveIcon.GetComponent<SplineWalker>().spline = currentActiveChallenge.GetComponent<BezierSpline>();

        string butterflyType = butterflyScript.GetSpeciesName();
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
}
