using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class YMovement : MonoBehaviour
{
    public float ysmoothTime = .3f;
    public float xsmoothTime = 0.5f;
    public float ymini =  - 1 ;
    public float ymax = 2.5f;
    public float xmini = -1;
    public float xmax = 1.5f;
    private float translationVel;

    public bool isWander;
    public Vector3 destinationVector3;
    //protected Seek ScriptSeek;

    [HideInInspector] public new Transform transform;

    private void Awake()
    {
        transform = GetComponent<Transform>();
        isWander = true;
        //ScriptSeek = GetComponent.NavMeshMovement.Seek<Seek>();
    }

    private void FixedUpdate()
    {
        if (isWander)
        {
            float yPos = Mathf.SmoothDamp(transform.localPosition.y, Random.Range(ymini, ymax), ref translationVel, ysmoothTime);
            //transform.localPosition = new Vector3(transform.localPosition.x, yPos, transform.localPosition.z);

            float xPos = Mathf.SmoothDamp(transform.localPosition.x, Random.Range(xmini, xmax), ref translationVel, xsmoothTime);
            transform.localPosition = new Vector3(xPos, yPos, transform.localPosition.z);

            //transform.LookAt(- transform.localPosition);
        }
      
    }

    public void GoToHeight(Vector3 destinationVector3)
    {
        if (isWander == false)
        {
            transform.Translate(destinationVector3);
        }
    }
}
