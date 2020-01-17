using UnityEngine;

namespace BehaviorDesigner.Runtime.Tasks.Movement
{
    [TaskCategory("Basic/Transform")]
    [TaskDescription("Change the base offset")]

  
    public class Ymovement : NavMeshMovement
    {

        public bool n_newchange;
        private float n_baseoffset;
        private float n_newbaseoffset;
        public float t = 0.005f;

        public override void OnStart()
        {
            n_baseoffset = navMeshAgent.baseOffset;
            n_newchange = true;
            //Debug.Log(n_baseoffset);
        }

        public override TaskStatus OnUpdate()
        {  
            if (n_newchange == true)
            {
                n_newchange = false;

                n_newbaseoffset = Random.Range(0.4f, 4f);
                Debug.Log(n_newbaseoffset);

                float n_oldbaseoffset = navMeshAgent.baseOffset;

                if (n_newbaseoffset != n_baseoffset)
                {
                    if( n_newbaseoffset > n_oldbaseoffset)
                    navMeshAgent.baseOffset = Mathf.SmoothStep(n_oldbaseoffset, n_newbaseoffset, t * Time.deltaTime);

                    else if (n_newbaseoffset < n_oldbaseoffset)
                        navMeshAgent.baseOffset = Mathf.SmoothStep(n_newbaseoffset, n_oldbaseoffset, t * Time.deltaTime);

                }
                n_newchange = true;
            }
            return TaskStatus.Running;



        }


       
    }
}
