﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FPScontroler : MonoBehaviour
{

    public CharacterController controller;
    public float speed = 10f;
    public float gravity = -9.81f;
    Vector3 velocity;
    public Transform Groundcheck;
    public float GroundDistance = 0.4f;
    public LayerMask groundMask;
    bool isGrounded;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        isGrounded = Physics.CheckSphere(Groundcheck.position, GroundDistance, groundMask);

        if (isGrounded && velocity.y < 0 )
        {
            velocity.y = -2f; 
        }

        float x = Input.GetAxis("Horizontal");
        float z = Input.GetAxis("Vertical");

        Vector3 move = transform.right * x + transform.forward * z;

        controller.Move(move * speed * Time.deltaTime);

        velocity.y += gravity * Time.deltaTime;

        controller.Move(velocity * Time.deltaTime);
    }
}
