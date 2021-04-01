using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;
public class CaughtIndexPanel : MonoBehaviour
{
    [Tooltip("All new butterflies to be registered")]
    //public string[] newButterflySpecies;
    public List<string> newButterflySpeciesList;

    [Tooltip("All valid butterfly species ingame")]
    public string[] allButterflySpecies;

    [Tooltip("All butterflies already registered")]
    public List<string> currentButterflySpecies;

    [Tooltip("All UI for Butterfles")]
    //Find way of serializing all variables below
    [SerializeField]
    private GameObject MonarchImage;
    public GameObject CabbageGO;
    public GameObject SaphoGO;
    public GameObject TigerSwallowGO;
    public GameObject BuckeyeGO;
    public GameObject BirdwingGO;
    public GameObject Ceylon_RoseGO;
    public GameObject EmeraldGO;
    public GameObject DragontailGO;
    public GameObject Cecropia_MothGO;
    public GameObject Luna_MothGO;
    public GameObject Japanese_Silk_MothGO;
    public GameObject Dysphania_Militaris_MothGO;
    public Sprite MonarchSprite;
    public Sprite CabbageSprite;
    public Sprite SaphoSprite;
    public Sprite TigerSwallowSprite;
    public Sprite BuckeyeSprite;
    public Sprite BirdwingSprite;
    public Sprite Ceylon_RoseSprite;
    public Sprite EmeraldSprite;
    public Sprite DragontailSprite;
    public Sprite Cecropia_MothSprite;
    public Sprite Luna_MothSprite;
    public Sprite Japanese_Silk_MothSprite;
    public Sprite Dysphania_Militaris_MothSprite;
    public int m_butterflyCreditsAmount = 0;
    private string currentButterflyToCheck;

    public void CheckIfSpeciesExists(string butterflyToCheck, ButterflyJar butterflyJar)
    {
        currentButterflyToCheck = butterflyToCheck;
        m_butterflyCreditsAmount = m_butterflyCreditsAmount + butterflyJar.yMoveScript.m_value;
        for(int i = 0; i < allButterflySpecies.Length; i++)
        {
            if(currentButterflyToCheck == allButterflySpecies[i])
            {
                TryToRegisterNewButterfly(butterflyJar);
            }
        }
    }

    private void TryToRegisterNewButterfly(ButterflyJar butterflyJar)
    {
        if(currentButterflySpecies.Contains(currentButterflyToCheck))
        {
            butterflyJar.m_jarCaptureVFX.Play();
            Debug.Log(currentButterflyToCheck + " is already registered");
        }else
        {
            butterflyJar.m_newJarCaptureVFX.Play();
            newButterflySpeciesList.Add(currentButterflyToCheck);
        }
    }

    public void UpdateButterflyIndexUI()
    {
        if(newButterflySpeciesList.Count != 0)
        {
            Debug.Log("Updating Papillodex");
            //Update with all other species + put function to get rid elements to update
            for(int i = 0; i < newButterflySpeciesList.Count; i++)
            {
                switch(newButterflySpeciesList[i])
                {
                    case "Monarch":
                        MonarchImage.GetComponent<SpriteRenderer>().sprite = MonarchSprite;
                        MonarchImage.GetComponent<BoxCollider>().enabled = true;
                        currentButterflySpecies.Add("Monarch");
                        newButterflySpeciesList.RemoveAt(i);
                    break;
                    case "Cabbage_White_Butterfly":
                        CabbageGO.GetComponent<SpriteRenderer>().sprite = CabbageSprite;
                        CabbageGO.GetComponent<BoxCollider>().enabled = true;
                        currentButterflySpecies.Add("Cabbage_White_Butterfly");
                        newButterflySpeciesList.RemoveAt(i);
                    break;
                    case "Sapho_Longwing":
                        SaphoGO.GetComponent<SpriteRenderer>().sprite = SaphoSprite;
                        SaphoGO.GetComponent<BoxCollider>().enabled = true;
                        currentButterflySpecies.Add("Sapho_Longwing");
                        newButterflySpeciesList.RemoveAt(i);
                    break;
                    case "Dragon_Tail":
                        DragontailGO.GetComponent<SpriteRenderer>().sprite = DragontailSprite;
                        DragontailGO.GetComponent<BoxCollider>().enabled = true;
                        currentButterflySpecies.Add("Dragon_Tail");
                        newButterflySpeciesList.RemoveAt(i);
                    break;
                    case "Japanese_Silk_Moth":
                        Japanese_Silk_MothGO.GetComponent<SpriteRenderer>().sprite = Japanese_Silk_MothSprite;
                        Japanese_Silk_MothGO.GetComponent<BoxCollider>().enabled = true;
                        currentButterflySpecies.Add("Japanese_Silk_Moth");
                        newButterflySpeciesList.RemoveAt(i);
                    break;
                    case "Ceylon_Rose":
                        Ceylon_RoseGO.GetComponent<SpriteRenderer>().sprite = Ceylon_RoseSprite;
                        Ceylon_RoseGO.GetComponent<BoxCollider>().enabled = true;
                        currentButterflySpecies.Add("Ceylon_Rose");
                        newButterflySpeciesList.RemoveAt(i);
                    break;
                    case "Dysphania_Militaris_Moth":
                        Dysphania_Militaris_MothGO.GetComponent<SpriteRenderer>().sprite = Dysphania_Militaris_MothSprite;
                        Dysphania_Militaris_MothGO.GetComponent<BoxCollider>().enabled = true;
                        currentButterflySpecies.Add("Dysphania_Militaris_Moth");
                        newButterflySpeciesList.RemoveAt(i);
                    break;
                    case "Emerald_Swallowtail":
                        EmeraldGO.GetComponent<SpriteRenderer>().sprite = EmeraldSprite;
                        EmeraldGO.GetComponent<BoxCollider>().enabled = true;
                        currentButterflySpecies.Add("Emerald_Swallowtail");
                        newButterflySpeciesList.RemoveAt(i);
                    break;
                    case "Southern_Birdwing":
                        BirdwingGO.GetComponent<SpriteRenderer>().sprite = BirdwingSprite;
                        BirdwingGO.GetComponent<BoxCollider>().enabled = true;
                        currentButterflySpecies.Add("Southern_Birdwing");
                        newButterflySpeciesList.RemoveAt(i);
                    break;
                    default:
                        Debug.LogError("Error while updating index UI");
                    break;
                }
            }
        }
    }

    public void UpdateCreditsUI(TextMeshProUGUI textToUpdate)
    {
        textToUpdate.text = m_butterflyCreditsAmount + " Butterfly Credits";
    }
}
