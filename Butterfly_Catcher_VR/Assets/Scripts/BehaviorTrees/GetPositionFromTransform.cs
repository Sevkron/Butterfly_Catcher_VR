using UnityEngine;

namespace BehaviorDesigner.Runtime.Tasks.Basic.UnityTransform
{
    [TaskCategory("Basic/Transform")]
    [TaskDescription("Stores the position of the Transform. Returns Success.")]
    public class GetPositionFromTransform : Action
    {
        [RequiredField]
        public SharedTransform targetTransform;
        [RequiredField]
        public SharedVector3 storeValue;
        //private Transform prevTransform;

        /*public override void OnStart()
        {
            var currentGameObject = GetDefaultGameObject(targetTransform.Value.gameObject);
            var currentTransform = currentGameObject.transform;
            if (currentTransform != prevTransform) {
                targetTransform = currentGameObject.GetComponent<Transform>();
                prevTransform = currentTransform;
            }
        }*/
        public override TaskStatus OnUpdate()
        {
            if (targetTransform == null) {
                Debug.LogWarning("Transform is null");
                return TaskStatus.Failure;
            }

            storeValue.Value = targetTransform.Value.position;

            return TaskStatus.Success;
        }

        public override void OnReset()
        {
            storeValue = Vector3.zero;
        }
    }
}