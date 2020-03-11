using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BehaviorDesigner.Runtime;
using Valve.VR.InteractionSystem;


public class TeleportNoiseDistance : MonoBehaviour
{
    //public float radiusNoise = 10f;
    private RaycastHit[] hits;
    //public GameObject[] butterflyGO;
    private Vector3 noiseCylinderScale;
    private bool noiseActivate = false;
    public Teleport teleportScript;
    private int increment = 0;
    public List<GameObject> listOfButterflies;
    void Start()
    {
        if(teleportScript == null)
        {
            teleportScript = GetComponentInParent<Teleport>();
        }
        listOfButterflies = new List<GameObject>();
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Butterfly"))
        {
            listOfButterflies.Add(other.gameObject);
            Debug.Log("Added butterfly" + other.gameObject.transform.parent + " to list");
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.gameObject.CompareTag("Butterfly"))
        {
            if (listOfButterflies.Contains(other.gameObject))
            {
                listOfButterflies.Remove(other.gameObject);
                Debug.Log("Removed butterfly" + other.gameObject.transform.parent + " from list");
            }
        }
    }
    void Update()
    {
        noiseCylinderScale = new Vector3(teleportScript.distanceFromPlayer, 1.9f, teleportScript.distanceFromPlayer);
        transform.localScale = noiseCylinderScale;
        //Gizmos.color = new Color(1, 0, 0, 0.5f);
            //NoiseTriggerEvent(teleportScript.distanceFromPlayer);

        if (teleportScript.teleporting == true)
        {
            NoiseTriggerEvent();
        }
    }

    public void NoiseTriggerEvent()
    {
        //listOfButterflies.GetRange(int index, int count);
        foreach(GameObject butterflyInList in listOfButterflies)
        {
            butterflyInList.GetComponentInParent<BehaviorTree>().SendEvent("hasHeardTP");
        }
    }
}