using UnityEngine;

namespace BehaviorDesigner.Runtime.Tasks.Movement
{
    [TaskCategory("Basic/Transform")]
    [TaskDescription("Change the base offset")]

  
    public class Ymovement : NavMeshMovement
    {
        public float ysmoothTime = .3f;
        public float xsmoothTime = 0.5f;
        public float ymini = -1;
        public float ymax = 2.5f;
        public float xmini = -1;
        public float xmax = 1.5f;
        private float translationVel;


        [HideInInspector] public new Transform transform;

        public override void OnAwake()
        {
            transform = GetComponent<Transform>();
        }

        public override TaskStatus OnUpdate()
        {
            float yPos = Mathf.SmoothDamp(transform.localPosition.y, Random.Range(ymini, ymax), ref translationVel, ysmoothTime);
            //transform.localPosition = new Vector3(transform.localPosition.x, yPos, transform.localPosition.z);

            float xPos = Mathf.SmoothDamp(transform.localPosition.x, Random.Range(xmini, xmax), ref translationVel, xsmoothTime);
            transform.localPosition = new Vector3(xPos, yPos, transform.localPosition.z);

            return TaskStatus.Running;
        }
        
    }

}

