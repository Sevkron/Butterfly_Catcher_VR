using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ReceiveHit : MonoBehaviour
{
    public MeshRenderer Renderer;
    public Material InstanceMaterial;
    // Start is called before the first frame update
    void Start()
    {
        Renderer = gameObject.GetComponent<MeshRenderer>();
        InstanceMaterial = Renderer.material;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void SetHitPosition(Vector3 hitPosition)
    {
        print(hitPosition);
        Vector3 hitVector = gameObject.transform.InverseTransformPoint(hitPosition);
        InstanceMaterial.SetVector("_hotpos", hitVector);
       
    }
}
