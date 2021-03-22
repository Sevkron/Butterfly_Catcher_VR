using UnityEngine;

namespace BehaviorDesigner.Runtime.Tasks.Basic.SharedVariables
{
    [TaskCategory("Basic/SharedVariable")]
    [TaskDescription("Gets the Transform + Vector 3 from the GameObject. Returns Success.")]
    public class SharedGameObjectToTransform : Action
    {
        [Tooltip("The GameObject to get the Transform + Vector3 + Rotation of")]
        public SharedGameObject sharedGameObject;

        [Tooltip("The Transform to set")]
        public SharedTransform sharedTransform;

        [Tooltip("The Vector3 to set")]
        public SharedVector3 sharedVector3;

        [Tooltip("The Rotation to set")]
        public SharedQuaternion sharedQuaternion;

        public override TaskStatus OnUpdate()
        {
            if (sharedGameObject.Value == null) {
                return TaskStatus.Failure;
            }

            sharedTransform.Value = sharedGameObject.Value.GetComponent<Transform>();
            sharedVector3.Value = sharedGameObject.Value.GetComponent<Transform>().position;
            sharedQuaternion.Value = sharedGameObject.Value.GetComponent<Transform>().rotation;

            return TaskStatus.Success;
        }

        public override void OnReset()
        {
            sharedGameObject = null;
            sharedTransform = null;
        }
    }
}