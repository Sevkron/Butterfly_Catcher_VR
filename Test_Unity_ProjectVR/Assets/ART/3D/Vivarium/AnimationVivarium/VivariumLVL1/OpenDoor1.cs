using System.Collections;
using System.Collections.Generic;
using UnityEngine;

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

            vivarium.GetComponent<Animator>().SetBool("PlayerNearDoor1", true);
            //audioManager.sounds
            audioManager.Play("OpenVivarium", GetComponentInChildren<AudioSource>());

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
