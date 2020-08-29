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
    public SpriteRenderer MonarchSpriteRenderer;
    public SpriteRenderer CabbageSpriteRenderer;
    public SpriteRenderer SaphoSpriteRenderer;
    public SpriteRenderer TigerSwallowSpriteRenderer;
    public SpriteRenderer BuckeyeSpriteRenderer;
    public SpriteRenderer BirdwingSpriteRenderer;
    public SpriteRenderer Ceylon_RoseSpriteRenderer;
    public SpriteRenderer EmeraldSpriteRenderer;
    public SpriteRenderer DragontailSpriteRenderer;
    public SpriteRenderer Cecropia_MothSpriteRenderer;
    public SpriteRenderer Luna_MothSpriteRenderer;
    public SpriteRenderer Japanese_Silk_MothSpriteRenderer;
    public SpriteRenderer Dysphania_Militaris_MothSpriteRenderer;
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
                return;
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
        if(newButterflySpeciesList.Count > 0)
        {
            for(int i = 0; i < newButterflySpeciesList.Count; i++)
            {
                if(newButterflySpeciesList[i] == "Monarch")
                {
                    MonarchSpriteRenderer.sprite = MonarchSprite;
                    //return;
                }else if(newButterflySpeciesList[i] == "Cabbage_White_Butterfly")
                {
                    CabbageSpriteRenderer.sprite = CabbageSprite;
                    //return;
                }else
                {
                    break;
                }
            }
        }
    }
}
