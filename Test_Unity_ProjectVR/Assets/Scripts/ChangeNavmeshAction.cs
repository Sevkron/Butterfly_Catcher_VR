using UnityEngine;

namespace BehaviorDesigner.Runtime.Tasks.Basic.UnityGameObject
{
    [TaskCategory("Basic/GameObject")]
    [TaskDescription("Deactivate Component")]
    public class DeactivateNavmesh : Action
    {
        [Tooltip("The GameObject that the task operates on. If null the task GameObject is used.")]
        public SharedGameObject targetGameObject;
        [Tooltip("The type of component")]
        public SharedString type;
        [Tooltip("The component")]
        [RequiredField]
        public SharedObject storeValue;

        public override TaskStatus OnUpdate()
        {
            storeValue.Value = GetDefaultGameObject(targetGameObject.Value).GetComponent(type.Value);
            targetGameObject.GetComponent<NavMeshAgent>().enabled = false;
            return TaskStatus.Success;
        }

        public override void OnReset()
        {
            targetGameObject = null;
            type.Value = "";
            storeValue.Value = null;
        }
    }
}