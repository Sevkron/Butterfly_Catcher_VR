using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MarcheSound : MonoBehaviour
{

    public int Location; // 0 Sable  1 Gravier
    public float tempsEntrePas;
    public AudioClip[] ClipDePas;
    public bool PasIsPlaying;

    public Vector3 getPos = Vector3.zero;
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
            Vector3 getPos = other.transform.position;

            StartCoroutine(WaitAndCheck());

            IEnumerator WaitAndCheck()
            {
                yield return new WaitForSeconds(0.01f);



                if (getPos != other.transform.position && PasIsPlaying == false)
                {
                    other.transform.hasChanged = false;
                    StartCoroutine(SystemeDePas());
                }


            }

        }
    }

    IEnumerator SystemeDePas()
    {
        PasIsPlaying = true;       
        AudioClip CurrentPas = ClipDePas[Random.Range(0, ClipDePas.Length)];
        GetComponent<AudioSource>().clip = CurrentPas;
        GetComponent<AudioSource>().Play();
        yield return new WaitForSeconds(tempsEntrePas);
        PasIsPlaying = false;
    }

    
}
