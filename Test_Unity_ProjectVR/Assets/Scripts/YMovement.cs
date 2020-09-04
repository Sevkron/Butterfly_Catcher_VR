using BehaviorDesigner.Runtime;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEngine.AI;
using DG.Tweening;
using Valve.VR.InteractionSystem;
public class YMovement : MonoBehaviour
{
    public enum ButterflySpecies{Monarch, Cabbage_White_Butterfly, Sapho_Longwing, Canadian_Tiger_Swallowtail, Common_Buckeye, Southern_Birdwing, Emerald_Swallowtail, Ceylon_Rose, Dragon_Tail, Cecropia_Moth, Luna_Moth, Japanese_Silk_Moth, Dysphania_Militaris_Moth}
    public ButterflySpecies butterflySpecies;
    public string stringButterflySpecies;

    [Tooltip("Must be set on integer between 0 and 3")]
    public int difficultyLevel;
    [Tooltip("Credit value of the butterfly")]
    public int m_value;

    public float _wanderSmoothTime = .3f;

    private Vector2 translationVel;

    private float range = 10f;

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

    public float m_MinWingVelocity = 1f;
    public float m_speedFactor=1f;

    private Player player = null;

    //public bool Idle;


    [HideInInspector] public new Transform transform;
    public Animator animator;
    public NavMeshAgent navMeshAgent;

    private Vector2 _targetWander;
    private Vector2 _currentWander;
    public float m_WanderRadius = 1f;
    public float m_WanderProbability;

    private void Awake()
    {
        transform = GetComponent<Transform>();
        navMeshAgent = GetComponentInParent<NavMeshAgent>();
        animator = GetComponentInParent<Animator>();
        butterflyBehaviorTree = GetComponentInParent<BehaviorTree>();
        isWander = true;
        stringButterflySpecies = butterflySpecies.ToString();

        BaseOffset = transform.parent.GetComponent<NavMeshAgent>().baseOffset;
    }

    private void Update()
    {
        if (isWander)
        {
            if (Vector2.Distance(_targetWander,_currentWander)<0.1f && Random.Range(0f,100f)>(100f-m_WanderProbability))
            {
                _targetWander = Random.insideUnitCircle * m_WanderRadius;
            }

            _currentWander = Vector2.SmoothDamp(_currentWander, _targetWander, ref translationVel, _wanderSmoothTime);


            transform.localPosition = _currentWander;



            animator.speed = Mathf.Max(m_MinWingVelocity, Vector2.Distance(_targetWander, _currentWander) * m_speedFactor );
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
            
            /*Sequence seq = DOTween.Sequence();
            //seq.Append(transform.parent.DOMove(new Vector3(hit.position.x, BaseOffset, hit.position.z), 1.5f));
            seq.Append(transform.parent.DORotate(new Vector3(0, 0, 0), 1.5f));
            seq.Join(transform.parent.DOScale(new Vector3(scale, scale, scale), 1f));
            seq.Join(transform.DORotate(new Vector3(0, 180, 0), 1.5f));
            seq.AppendCallback(() =>  {*/
                NavMeshAgent navButterfly = JarScript.ButterflyinJar.GetComponentInParent<NavMeshAgent>();
                navButterfly.enabled = true;
                navButterfly.Warp(new Vector3(hit.position.x, BaseOffset, hit.position.z));

                transform.parent.DORotate(new Vector3(0, 0, 0), 1.5f);
                transform.parent.DOScale(new Vector3(scale, scale, scale), 1f);
                transform.DORotate(new Vector3(0, 180, 0), 1.5f);

                Debug.DrawRay(point, Vector3.up, Color.blue, 1.0f);

                JarScript.ButterflyinJar.GetComponent<SphereCollider>().enabled = true;
                isWander = true;

                JarScript.hasButterfly = false;
                JarScript.Butterflycatched = false;
                
                //Try using the Warp function
                
                butterflyBehaviorTree.SendEvent("IsFreeJar");
            /*})*/;
            
        }else
        {
            Debug.LogError("No point on NavMesh found for " + gameObject.transform.parent);
            //Destroy to get rid of butterfly
            Destroy(transform.parent.gameObject);
        }
    }

    bool RandomPoint(Vector3 center, float range, out Vector3 result)
    {
        int vivariumMask = 1 << NavMesh.GetAreaFromName("Vivariums");
        int flyingMask = 1 << NavMesh.GetAreaFromName("Flying");
        //Debug.Log("The vivariumMask is " + vivariumMask);
        
        player = Player.instance;

         if(player.isInVivarium == true)
         {
            for (int i = 0; i < 1000; i++)
            {
                Vector3 randomPoint = center + Random.insideUnitSphere * range;
           
                if (NavMesh.SamplePosition(randomPoint, out hit, 1.0f, vivariumMask)) //switch back to vivariumMask
                {
                    result = hit.position;
                    return true;
                }
            }
        }else
        {
            for (int i = 0; i < 1000; i++)
            {
                Vector3 randomPoint = center + Random.insideUnitSphere * range;
           
                if (NavMesh.SamplePosition(randomPoint, out hit, 1.0f, flyingMask)) //switch back to vivariumMask
                {
                    result = hit.position;
                    return true;
                }
            }
        }
        result = Vector3.zero;
        return false;
        
    }

}
