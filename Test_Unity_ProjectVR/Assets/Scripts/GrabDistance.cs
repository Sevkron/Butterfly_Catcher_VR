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

        public float maxDistance = 10f;
        bool isActive = false;
        public bool addRigidBody = false;

    // Start is called before the first frame update
        void Start()
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
            Material newMaterial = new Material(Shader.Find("Unlit/Color"));
            newMaterial.SetColor("_Color", color);
            pointer.GetComponent<MeshRenderer>().material = newMaterial;
        }

    // Update is called once per frame
        void Update()
        {
            Ray raycast = new Ray(transform.position, transform.forward);
            RaycastHit priorityHit;
            bool bHit = Physics.Raycast(raycast, out priorityHit, maxDistance);

            RaycastHit hit;
            float distanceToObstacle = 0;

            if(Physics.SphereCast(transform.position, 0.1f, transform.forward, out hit, maxDistance))
            {
                if(hit.transform.gameObject.GetComponent<Interactable>() != null && hit.transform.gameObject == priorityHit.transform.gameObject)
                {
                    this.GetComponentInParent<Hand>().hoveringInteractable = hit.transform.gameObject.GetComponent<Interactable>();
                    pointer.SetActive(true);
                }
                else if(priorityHit.transform.gameObject.GetComponent<Interactable>() != null)
                    this.GetComponentInParent<Hand>().hoveringInteractable = priorityHit.transform.gameObject.GetComponent<Interactable>();
            }
            else
                pointer.SetActive(false);
        }
    }
}
