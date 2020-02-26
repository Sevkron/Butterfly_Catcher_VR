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
        RaycastHit hit;
        Physics.SphereCastAll(transform.position, radiusNoise, transform.forward, out hit);
        
    }
}
