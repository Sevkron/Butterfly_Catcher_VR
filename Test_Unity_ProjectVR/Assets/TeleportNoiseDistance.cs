using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TeleportNoiseDistance : MonoBehaviour
{
    public float radiusNoise;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        RaycastHit[] hits;
        hits = Physics.SphereCastAll(transform.position, radiusNoise, transform.forward);
        for(int i = 0; i < hits.Length; i++)
        {
            
        }
    }
}
