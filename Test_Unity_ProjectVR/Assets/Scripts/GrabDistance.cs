using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Valve.VR.InteractionSystem{
    public class GrabDistance : MonoBehaviour
    {
        public Color color;
        public float thickness = 0.002f;
        //public Color clickColor = Color.green;
        public GameObject holder;
        public GameObject pointer;
        public Transform raycastDirection;
        public float radiusSphereCast;
        public float maxDistance = 100f;
        public bool isActive = true;
        public bool addRigidBody = false;

    // Start is called before the first frame update
        void Start()
        {
            if(raycastDirection == null)
                raycastDirection = this.transform;

            if(isActive == true)
            {
                holder = new GameObject();
                holder.transform.parent = this.transform;
                holder.transform.localPosition = raycastDirection.transform.localPosition;
                holder.transform.localRotation = raycastDirection.transform.localRotation;

                pointer = GameObject.CreatePrimitive(PrimitiveType.Cube);
                pointer.transform.parent = holder.transform;
                pointer.transform.localScale = new Vector3(thickness, thickness, maxDistance);
                pointer.transform.localPosition = new Vector3(0f, 0f, 50f);
                pointer.transform.localRotation = Quaternion.identity;
                
                BoxCollider collider = pointer.GetComponent<BoxCollider>();
            
                if (addRigidBody)
                {
                    if (collider)
                    {
                        collider.isTrigger = true;
                    }
                    Rigidbody rigidBody = pointer.AddComponent<Rigidbody>();
                    rigidBody.isKinematic = true;

                }
                else
                {
                    if (collider)
                    {
                        Object.Destroy(collider);
                    }
                }
            }
            Material newMaterial = new Material(Shader.Find("Unlit/Color"));
            newMaterial.SetColor("_Color", color);
            pointer.GetComponent<MeshRenderer>().material = newMaterial;
        }

        void Update()
        {
            RaycastHit hit;
            RaycastHit priorityHit;
            Ray priorityRaycast = new Ray(raycastDirection.transform.position, raycastDirection.transform.forward);

            GameObject selectedGameObject;

            if(Physics.Raycast(priorityRaycast, out priorityHit, maxDistance) && priorityHit.transform.gameObject.GetComponent<Interactable>() != null && GetComponent<Hand>().currentAttachedObject == null)
            {
                selectedGameObject = priorityHit.transform.gameObject;
                GrabUpdate(true, maxDistance);
                this.GetComponentInParent<Hand>().hoveringInteractable = selectedGameObject.GetComponent<Interactable>();
            }
            else if(Physics.SphereCast(raycastDirection.transform.position, radiusSphereCast, raycastDirection.transform.forward, out hit, maxDistance) && hit.transform.gameObject.GetComponent<Interactable>() != null && GetComponent<Hand>().currentAttachedObject == null)
            {
                selectedGameObject = hit.transform.gameObject;
                GrabUpdate(true, maxDistance);
                this.GetComponentInParent<Hand>().hoveringInteractable = selectedGameObject.GetComponent<Interactable>();
            }
            else
            {
                GrabUpdate(false, maxDistance);
            }
        }

        public void GrabUpdate(bool set, float distance)
        {
            if(isActive == true)
            {
                pointer.SetActive(set);
                pointer.transform.localScale = new Vector3(thickness, thickness, distance);
            }
            
        }
    }
}
