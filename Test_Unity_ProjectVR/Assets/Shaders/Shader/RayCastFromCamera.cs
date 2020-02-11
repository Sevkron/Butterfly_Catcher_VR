using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RayCastFromCamera : MonoBehaviour
{
    

    Ray ray;
    // Start is called before the first frame update
    void Start()
    {
        

    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit, 100f))
            {
                
            
                ReceiveHit ReceiveHit = hit.collider.gameObject.GetComponent<ReceiveHit>();
                if (ReceiveHit)
                {
                    ReceiveHit.SetHitPosition(hit.point);
                }
            }
        }
    }
}
