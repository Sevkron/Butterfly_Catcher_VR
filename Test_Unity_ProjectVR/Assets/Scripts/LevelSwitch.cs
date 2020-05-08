using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;

public class LevelSwitch : MonoBehaviour
{
    // Start is called before the first frame update
    //public SteamVR_LoadLevel LevelLoader;
    public string[] LevelNames = new string[2] {"LDScene", "MENU"};
    static LevelSwitch s = null;
    public int currLevel = 1;
    void Start()
    {
        if (s == null)
            s = this;
        else
            Destroy(this.gameObject);    
        
        DontDestroyOnLoad(this.gameObject);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.anyKeyDown)
        {
            currLevel = (currLevel + 1) % 2;
            SteamVR_LoadLevel.Begin(LevelNames[currLevel]);
        }
    }
}
