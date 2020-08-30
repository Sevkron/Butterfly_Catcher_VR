using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CaughtIndexPanel : MonoBehaviour
{
    [Tooltip("All new butterflies to be registered")]
    //public string[] newButterflySpecies;
    public List<string> newButterflySpeciesList;

    [Tooltip("All valid butterfly species ingame")]
    public string[] allButterflySpecies;

    [Tooltip("All butterflies already registered")]
    public string[] currentButterflySpecies;
    [Tooltip("All UI for Butterfles")]
    public GameObject MonarchGO;
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

    private string currentButterflyToCheck;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void CheckIfSpeciesExists(string butterflyToCheck)
    {
        currentButterflyToCheck = butterflyToCheck;
        for(int i = 0; i < allButterflySpecies.Length; i++)
        {
            if(currentButterflyToCheck == allButterflySpecies[i])
            {
                TryToRegisterNewButterfly();
            }
        }
    }

    private void TryToRegisterNewButterfly()
    {
        if(newButterflySpeciesList.Contains(currentButterflyToCheck))
        {
            Debug.Log(currentButterflyToCheck + " is already registered");
        }else
        {
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
                if(newButterflySpeciesList[i] == "Monarch")
                {
                    MonarchGO.GetComponent<SpriteRenderer>().sprite = MonarchSprite;
                    MonarchGO.GetComponent<BoxCollider>().enabled = true;
                    //return;
                }
                if(newButterflySpeciesList[i] == "Cabbage_White_Butterfly")
                {
                    CabbageGO.GetComponent<SpriteRenderer>().sprite = CabbageSprite;
                    CabbageGO.GetComponent<BoxCollider>().enabled = true;
                    //return;
                }
                if(newButterflySpeciesList[i] == "Sapho_Longwing")
                {
                    SaphoGO.GetComponent<SpriteRenderer>().sprite = SaphoSprite;
                    SaphoGO.GetComponent<BoxCollider>().enabled = true;
                    //return;

                }
                if(newButterflySpeciesList[i] == "Dragon_Tail")
                {
                    DragontailGO.GetComponent<SpriteRenderer>().sprite = DragontailSprite;
                    DragontailGO.GetComponent<BoxCollider>().enabled = true;
                    //return;

                }
                if(newButterflySpeciesList[i] == "Japanese_Silk_Moth")
                {
                    Japanese_Silk_MothGO.GetComponent<SpriteRenderer>().sprite = Japanese_Silk_MothSprite;
                    Japanese_Silk_MothGO.GetComponent<BoxCollider>().enabled = true;
                    //return;

                }
                if(newButterflySpeciesList[i] == "Ceylon_Rose")
                {
                    Ceylon_RoseGO.GetComponent<SpriteRenderer>().sprite = Ceylon_RoseSprite;
                    Ceylon_RoseGO.GetComponent<BoxCollider>().enabled = true;
                    //return;

                }
                if(newButterflySpeciesList[i] == "Dysphania_Militaris_Moth")
                {
                    Dysphania_Militaris_MothGO.GetComponent<SpriteRenderer>().sprite = Dysphania_Militaris_MothSprite;
                    Dysphania_Militaris_MothGO.GetComponent<BoxCollider>().enabled = true;
                    //return;

                }
                if(newButterflySpeciesList[i] == "Emerald_Swallowtail")
                {
                    EmeraldGO.GetComponent<SpriteRenderer>().sprite = EmeraldSprite;
                    EmeraldGO.GetComponent<BoxCollider>().enabled = true;
                    //return;

                }
                if(newButterflySpeciesList[i] == "Southern_Birdwing")
                {
                    BirdwingGO.GetComponent<SpriteRenderer>().sprite = BirdwingSprite;
                    BirdwingGO.GetComponent<BoxCollider>().enabled = true;
                    //return;

                }
            }
        }
    }
}
