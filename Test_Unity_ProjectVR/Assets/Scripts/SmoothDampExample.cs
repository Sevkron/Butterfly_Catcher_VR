using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SmoothDampExample : MonoBehaviour
{
    public float smoothTime = .1f;
    public float translation;
    private float translationVel;
    
    [HideInInspector] public new Transform transform;

    private void Awake()
    {
        transform = GetComponent<Transform>();
    }

    private void Update()
    {
        float yPos = Mathf.SmoothDamp(transform.localPosition.y, Random.Range(-translation, translation), ref translationVel, smoothTime);
        transform.localPosition = new Vector3(transform.localPosition.x, yPos, transform.localPosition.z);
    }
}
