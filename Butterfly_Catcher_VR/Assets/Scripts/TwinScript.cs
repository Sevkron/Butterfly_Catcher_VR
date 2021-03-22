using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR.InteractionSystem;

public class TwinScript : MonoBehaviour
{
    private bool hasGrabbedOnce = false;
    private Interactable interactible;
    private AudioManager audioManager;
    public bool isTwin1;
    // Start is called before the first frame update
    void Awake()
    {
        interactible = GetComponent<Interactable>();
        audioManager = FindObjectOfType<AudioManager>();
    }

    // Update is called once per frame
    void Update()
    {
        if(hasGrabbedOnce == false && interactible.attachedToHand)
        {
            hasGrabbedOnce = true;
            if(isTwin1)
                audioManager.Play("SecretMusic1", GetComponent<AudioSource>());
            else
            {
                audioManager.Play("SecretMusic2", GetComponent<AudioSource>());
            }  
            Destroy(this);
        }
    }
}
