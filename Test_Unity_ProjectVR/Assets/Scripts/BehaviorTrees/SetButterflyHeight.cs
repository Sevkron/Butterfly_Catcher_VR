using UnityEngine;

namespace BehaviorDesigner.Runtime.Tasks.Movement
{
    [TaskCategory("Movement")]
    [TaskDescription("Set destination Vector3 of butterfly")]

    public class SetButterflyHeight : Action
    {
        [Tooltip("The first variable to compare")]
        public SharedGameObject targetObject;
        [Tooltip("Send to script")]
        public Vector3 targetVector3;

        protected YMovement scriptYMove;
        // Start is called before the first frame update

        public override void OnAwake()
        {
            scriptYMove = GetComponent<YMovement>();
        }
        public override TaskStatus OnUpdate()
        {
            if (targetObject.Value == null)
            {
                return TaskStatus.Failure;
            }

            scriptYMove.GoToHeight(targetObject.Value.transform.position);
            scriptYMove.isWander = false;

            return TaskStatus.Success;
        }
    }
}
