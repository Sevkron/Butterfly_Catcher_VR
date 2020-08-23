using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR.InteractionSystem;

public class OpenDoor2 : MonoBehaviour
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

            vivarium.GetComponent<Animator>().SetBool("PlayerNearDoor2", true);
            audioManager.Play("OpenVivarium2", GetComponentInChildren<AudioSource>());
            other.gameObject.GetComponentInParent<Player>().isInVivarium = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {

            vivarium.GetComponent<Animator>().SetBool("PlayerNearDoor2", false);
            audioManager.Play("CloseVivarium2", GetComponentInChildren<AudioSource>());

        }
    }
}
