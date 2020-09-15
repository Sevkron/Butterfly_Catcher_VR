using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;

public class CameraColliderFade : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void OnTriggerStay()
    {
        SteamVR_Fade.Start(Color.grey, 0);
    }

    void OnTriggerExit()
    {
        SteamVR_Fade.Start(Color.clear, 1);
    }
}
