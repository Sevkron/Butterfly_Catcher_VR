using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CaughtIndexPanel : MonoBehaviour
{
    [Tooltip("All new butterflies to be registered")]
    public string[] newButterflySpecies;

    [Tooltip("All valid butterfly species ingame")]
    public string[] allButterflySpecies;

    [Tooltip("All butterflies already registered")]
    public string[] currentButterflySpecies;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void RegisterNewButterfly()
    {
        if(newButterflySpecies != null)
        {

        }
    }
}
