using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;

public class LevelSwitch : MonoBehaviour
{
    // Start is called before the first frame update
    public SteamVR_LoadLevel LevelLoader;
    void Start()
    {
        DontDestroyOnLoad(this.gameObject);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.anyKeyDown)
        {
            LevelLoader.Trigger();
        }

    }
}
