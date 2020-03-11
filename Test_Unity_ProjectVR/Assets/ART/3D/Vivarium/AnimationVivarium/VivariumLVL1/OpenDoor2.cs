using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OpenDoor2 : MonoBehaviour
{
    public GameObject vivarium;
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {

            vivarium.GetComponent<Animator>().SetBool("PlayerNearDoor2", true);
            FindObjectOfType<AudioManager>().Play("OpenVivarium2", GetComponentInChildren<AudioSource>());

        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {

            vivarium.GetComponent<Animator>().SetBool("PlayerNearDoor2", false);
            FindObjectOfType<AudioManager>().Play("CloseVivarium2", GetComponentInChildren<AudioSource>());

        }
    }
}
