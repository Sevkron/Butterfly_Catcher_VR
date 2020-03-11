using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OpenDoor1 : MonoBehaviour
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

            vivarium.GetComponent<Animator>().SetBool("PlayerNearDoor1", true);
            FindObjectOfType<AudioManager>().Play("OpenVivarium");

        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {

            vivarium.GetComponent<Animator>().SetBool("PlayerNearDoor1", false);
            FindObjectOfType<AudioManager>().Play("CloseVivarium");

        }
    }
}
