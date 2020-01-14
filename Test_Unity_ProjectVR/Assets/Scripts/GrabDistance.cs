using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Valve.VR.InteractionSystem{
    public class GrabDistance : MonoBehaviour
    {
        public Color color;
        public float thickness = 0.002f;
        public Color clickColor = Color.green;
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
                raycastDirection = GetComponentInParent<Hand>().objectAttachmentPoint;

            if(isActive)
            {
                holder = new GameObject();
                holder.transform.parent = this.transform;
                holder.transform.localPosition = Vector3.zero;
                holder.transform.localRotation = Quaternion.identity;

                pointer = GameObject.CreatePrimitive(PrimitiveType.Cube);
                pointer.transform.parent = holder.transform;
                pointer.transform.localScale = new Vector3(thickness, thickness, maxDistance);
                pointer.transform.localPosition = new Vector3(0f, 0f, 50f);
                pointer.transform.localRotation = Quaternion.identity;
                //pointer.transform.localRotation = Quaternion.Euler(pointer.transform.localRotation.x + 90, pointer.transform.localRotation.y, pointer.transform.localRotation.z);
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

    // Update is called once per frame
        void Update()
        {
            RaycastHit hit;
            RaycastHit priorityHit;
//new version
            //Ray priorityRaycast = new Ray(transform.position, transform.forward);
            Ray priorityRaycast = new Ray(transform.position, new Vector3(transform.position.x - 1, transform.position.y, transform.position.z));
            GameObject selectedGameObject;

            if(Physics.Raycast(priorityRaycast, out priorityHit, maxDistance) && priorityHit.transform.gameObject.GetComponent<Interactable>() != null)
            {
                selectedGameObject = priorityHit.transform.gameObject;
                GrabUpdate(true, maxDistance);
                this.GetComponentInParent<Hand>().hoveringInteractable = selectedGameObject.GetComponent<Interactable>();
            }
            else if(Physics.SphereCast(transform.position, radiusSphereCast, new Vector3(transform.position.x - 1, transform.position.y, transform.position.z), out hit, maxDistance) && hit.transform.gameObject.GetComponent<Interactable>() != null)
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
            if(isActive)
            {
                pointer.SetActive(set);
                pointer.transform.localScale = new Vector3(thickness, thickness, distance);
            }
            
        }
    }
}
