using BehaviorDesigner.Runtime;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
using DG.Tweening;

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

    private float range = 0.5f;

    public bool isWander;
    public Vector3 destinationVector3;
    public ButterflyJar JarScript;
    public BehaviorTree butterflyBehaviorTree;
    //protected Seek ScriptSeek;
    NavMeshHit hit;
    public GameObject Paps;
    public float BaseOffset;
    public SharedBool SharedIsIdle;

    public float scale = 1;

    //public bool Idle;


    [HideInInspector] public new Transform transform;
    [HideInInspector] public Animator animator;
    [HideInInspector] public NavMeshAgent navMeshAgent;

    private void Awake()
    {
        transform = GetComponent<Transform>();
        navMeshAgent = GetComponentInParent<NavMeshAgent>();
        animator = GetComponentInParent<Animator>();
        butterflyBehaviorTree = GetComponentInParent<BehaviorTree>();
        isWander = true;
        
        //JarScript = GetComponentInChildren<ButterflyJar>();//nope
        BaseOffset = transform.parent.GetComponent<NavMeshAgent>().baseOffset;
        


}

    private void FixedUpdate()
    {
        if (isWander)
        {
            float yPos = Mathf.SmoothDamp(transform.localPosition.y, Random.Range(ymini, ymax), ref translationVel, ysmoothTime);
            transform.localPosition = new Vector3(transform.localPosition.x, yPos, transform.localPosition.z);

            float xPos = Mathf.SmoothDamp(transform.localPosition.x, Random.Range(xmini, xmax), ref translationVel, xsmoothTime);
            transform.localPosition = new Vector3(xPos, transform.localPosition.y, transform.localPosition.z);

          

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

    public IEnumerator Delay()
    {
        
        Debug.Log("Start Delay Coroutine");
        yield return new WaitForSeconds(2);

            //transform.parent.DetachChildren();
            //ou
        transform.parent.SetParent(null);

        Vector3 point;
        if (RandomPoint(transform.position, range, out point))
        {  
            transform.parent.DOMove(new Vector3(hit.position.x, BaseOffset, hit.position.z), 1.5f);
            transform.parent.DORotate(new Vector3(0, 0, 0), 1.5f);
            JarScript.ButterflyinJar.GetComponentInParent<NavMeshAgent>().enabled = true;
            SharedIsIdle = (SharedBool)butterflyBehaviorTree.GetVariable("IsIdle");
            SharedIsIdle = false;
            //Instantiate(Paps, new Vector3(hit.position.x, BaseOffset , hit.position.z), Quaternion.identity);
            Debug.DrawRay(point, Vector3.up, Color.blue, 1.0f);
            //JarScript.SharedIsIdle = false;
        }

        JarScript.ButterflyinJar.GetComponent<SphereCollider>().enabled = true;
        isWander = true;

        //ajouter le collider
        //butterflyBehaviorTree = JarScript.ButterflyinJar.GetComponent<BehaviorTree>();
        JarScript.hasButterfly = false;
        JarScript.Butterflycatched = false;
        transform.parent.transform.localScale = new Vector3(scale, scale, scale);
        
        butterflyBehaviorTree.SendEvent<object>("IsFreeJar", null);
        //Destroy(JarScript.ButterflyinJar.transform.parent.gameObject);
    }

    bool RandomPoint(Vector3 center, float range, out Vector3 result)
    {
        for (int i = 0; i < 30; i++)
        {
            Vector3 randomPoint = center + Random.insideUnitSphere * range;
           
            if (NavMesh.SamplePosition(randomPoint, out hit, 1.0f, NavMesh.AllAreas))
            {
                result = hit.position;
                return true;
            }
        }
        result = Vector3.zero;
        return false;
    }

}
