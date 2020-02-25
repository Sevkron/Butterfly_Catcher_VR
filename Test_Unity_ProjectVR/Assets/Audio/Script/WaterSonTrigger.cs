using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterSonTrigger : MonoBehaviour
{

    public GameObject[] distantPoint;
    public AudioSource audioSource;
    public GameObject player;
    public float[] vector3Tab;
    public float minVector3;
    public GameObject ZonePlusProche;
    public float ValeurMaxLerp;

    void Start()
    {

    }

    void Update()
    {
        
    }
    private void OnTriggerStay(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            for (int i = 0; i < distantPoint.Length; i++)
            {
                vector3Tab[i] = Vector3.Distance(distantPoint[i].transform.position, player.transform.position);

                if (i == 0)
                {
                    minVector3 = vector3Tab[i];
                    ZonePlusProche = distantPoint[i];
                }

                if (Mathf.Abs(minVector3) > Mathf.Abs(vector3Tab[i]))
                {
                    minVector3 = vector3Tab[i];
                    ZonePlusProche = distantPoint[i];
                }
            }

            audioSource.transform.position = ZonePlusProche.transform.position;
        }
        audioSource.volume = Mathf.InverseLerp(0, ValeurMaxLerp , ValeurMaxLerp-minVector3);
    }


    private void OnTriggerExit(Collider other)
    {
        audioSource.volume = 0;
    }
}
