using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SinExample : MonoBehaviour
{
    public float translation;
    public float speed;

    private void Update()
    {
        float yPos = Mathf.LerpUnclamped(0, translation, Mathf.Sin(Time.time * speed));
        transform.position = new Vector3(transform.position.x, yPos, transform.position.z);
    }
}
