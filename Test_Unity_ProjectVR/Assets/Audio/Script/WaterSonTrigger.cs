using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterSonTrigger : MonoBehaviour
{

    public GameObject[] distantPoint;
    public AudioSource[] audioSourceList;
    public GameObject player;
    public float[] vector3Tab;
    public float minVector3;
    public GameObject ZonePlusProche;
    public float ValeurMaxLerp;

    public float minDistance;
    public List<GameObject> ZonesProches = new List<GameObject>(2);

    void Start()
    {
        for (int i = 0; i < audioSourceList.Length; i++)
        {
            audioSourceList[i].Play();

        }

    }

    void Update()
    {
        
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.gameObject.tag == "Player" )
        {
            GameObject closest1 = null;

            for (int i = 0; i < distantPoint.Length; i++)
            {

                vector3Tab[i] = Vector3.Distance(distantPoint[i].transform.position, other.gameObject.transform.position);

                if (i == 0)
                {
                    minVector3 = vector3Tab[i];
                    closest1 = distantPoint[i];
                }


                if (i > 0)
                {


                    if (Mathf.Abs(minVector3) > Mathf.Abs(vector3Tab[i]))
                    {
                        minVector3 = vector3Tab[i];
                        closest1 = distantPoint[i];
                    }
                    ZonePlusProche = closest1;
                }
            }          
        }

        for (int i = 0; i < audioSourceList.Length; i++)
        {
            audioSourceList[i].volume = Mathf.InverseLerp(0, ValeurMaxLerp , ValeurMaxLerp-minVector3);

        }
    }


    private void OnTriggerExit(Collider other)
    {

        for (int i = 0; i < audioSourceList.Length; i++)
        {
            audioSourceList[i].volume = 0;

        }

    }
}
