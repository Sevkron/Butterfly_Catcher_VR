using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR.InteractionSystem;

public class OpenDoor1 : MonoBehaviour
{

    public GameObject vivarium;
    private AudioManager audioManager;
    void Start()
    {
        audioManager = FindObjectOfType<AudioManager>();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            Debug.Log(this + "found player");
            vivarium.GetComponent<Animator>().SetBool("PlayerNearDoor1", true);
            //audioManager.sounds
            audioManager.Play("OpenVivarium", GetComponentInChildren<AudioSource>());
            other.gameObject.GetComponentInParent<Player>().isInVivarium = false;

        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {

            vivarium.GetComponent<Animator>().SetBool("PlayerNearDoor1", false);
            audioManager.Play("CloseVivarium", GetComponentInChildren<AudioSource>());

        }
    }
}
