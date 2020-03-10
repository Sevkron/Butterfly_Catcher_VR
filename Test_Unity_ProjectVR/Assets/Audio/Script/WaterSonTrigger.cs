using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterSonTrigger : MonoBehaviour
{

    public GameObject[] distantPoint;
    public AudioSource audioSource1;
    public AudioSource audioSource2;
    public GameObject player;
    public float[] vector3Tab;
    public float minVector3;
    public float minVector32;
    public GameObject ZonePlusProche;
    public GameObject ZonePlusProche2;
    public float ValeurMaxLerp;

    public float minDistance;
    public List<GameObject> ZonesProches = new List<GameObject>(2);

    void Start()
    {
        audioSource1.Play();
        audioSource2.Play();

    }

    void Update()
    {
        
    }

    private void OnTriggerStay(Collider other)
    {
        /*if (other.gameObject.tag == "Player" )
        {
            GameObject closest1 = null;
            GameObject closest2 = null;

            for (int i = 0; i < distantPoint.Length; i++)
            {

                vector3Tab[i] = Vector3.Distance(distantPoint[i].transform.position, other.gameObject.transform.position);

                if (i == 0)
                {
                    minVector3 = vector3Tab[i];
                    closest1 = distantPoint[i];
                }

                if (i == 1)
                {
                    minVector32 = vector3Tab[i];
                    closest2 = distantPoint[i];
                }

                if (i > 1)
                {
                    if (Mathf.Abs(minVector3) < Mathf.Abs(minVector32))
                    {
                        float NewValues = minVector3;
                        minVector3 = minVector32;
                        minVector32 = NewValues;
                    }

                    if (Mathf.Abs(minVector3) > Mathf.Abs(vector3Tab[i]))
                    {
                        minVector3 = vector3Tab[i];
                        closest1 = distantPoint[i];
                    }
                    else if (Mathf.Abs(minVector32) > Mathf.Abs(vector3Tab[i]))
                    {
                        minVector32 = vector3Tab[i];
                        closest2 = distantPoint[i];
                    }

                    if (Mathf.Abs(minVector3) < Mathf.Abs(minVector32))
                    {
                        float NewValues = minVector3;
                        minVector3 = minVector32;
                        minVector32 = NewValues;
                    }

                    ZonePlusProche = closest1;
                    ZonePlusProche2 = closest2;

                }
            }

                audioSource1.transform.position = ZonePlusProche.transform.position;
                audioSource2.transform.position = ZonePlusProche2.transform.position;
            
        }
        audioSource1.volume = Mathf.InverseLerp(0, ValeurMaxLerp , ValeurMaxLerp-minVector3);
        audioSource2.volume = Mathf.InverseLerp(0, ValeurMaxLerp, ValeurMaxLerp - minVector32);*/
        

    }


    private void OnTriggerExit(Collider other)
    {
        audioSource1.volume = 0;
        audioSource2.volume = 0;

    }
}
