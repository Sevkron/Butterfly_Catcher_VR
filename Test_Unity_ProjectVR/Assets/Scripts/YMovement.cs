using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class YMovement : MonoBehaviour
{
    [Tooltip("Must be set on integer between 0 and 3")]
    public int difficultyLevel;

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
    [HideInInspector] public Animator animator;
    [HideInInspector] public NavMeshAgent navMeshAgent;

    private void Awake()
    {
        transform = GetComponent<Transform>();
        navMeshAgent = GetComponentInParent<NavMeshAgent>();
        animator = GetComponentInParent<Animator>();
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

            /*float min = 0.1f;
            float max = 2f;
            float i;
            float normalizedFloat; */

            animator.speed = navMeshAgent.speed;
            //Debug.Log(navMeshAgent.speed);
            //transform.LookAt(- transform.localPosition);
        }
      
    }

    public void GoToHeight(Vector3 destinationVector3)
    {
        isWander = false;
        transform.Translate(destinationVector3);
    }

    public void GoToDefaultPos()
    {
        isWander = false;
        transform.localRotation = Quaternion.identity;
        transform.localPosition = new Vector3(0, 0, 0);
        //enabled = false;
    }
}
