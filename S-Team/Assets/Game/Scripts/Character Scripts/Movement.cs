using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement : MonoBehaviour
{
    CharacterController characterController;
    Animator anim;

    public bool restrict_movement = false;

    public float speed = 6.0f;
    public float slowSpeed = 0.5f;
    public float jumpSpeed = 8.0f;
    public float gravity = 20.0f;

    public float turnSmoothTime = 0.1f;
    float turnSmoothVelocity;

    public Vector3 moveDirection = Vector3.zero;
    public EngineerPush ePush;

    private AudioSource runningSound;
    private float walk_time = 0f; 

    void Start()
    {
        characterController = GetComponent<CharacterController>();
        anim = GetComponent<Animator>();
        ePush = GetComponent<EngineerPush>();
        runningSound = GetComponent<AudioSource>(); 
    }

    void Update()
    {
        float horizontal = Input.GetAxis("Horizontal");
        float vertical = Input.GetAxis("Vertical");

        if (restrict_movement)
        {
            horizontal = 0f;
            vertical = 0f;
        }

        Vector3 dir = new Vector3(horizontal, 0.0f, vertical);

        if(dir.magnitude > 0.1f)// only rotate when moving
        {
            float targetAngle = Mathf.Atan2(dir.x, dir.z) * Mathf.Rad2Deg;
            float angle = Mathf.SmoothDampAngle(transform.eulerAngles.y, targetAngle, ref turnSmoothVelocity, turnSmoothTime);
            transform.rotation = Quaternion.Euler(0f, angle, 0f);
        }
        

        if (characterController.isGrounded)
        {
            anim.SetBool("Grounded", true);

            // We are grounded, so recalculate
            // move direction directly from axes
            //moveDirection = dir;

            moveDirection = dir;

            if (ePush == null)
                moveDirection *= speed;
            else
                moveDirection *= ePush.isPushing ? slowSpeed : speed;

            //change animation
            float param_value = Mathf.Abs(moveDirection.magnitude);
            anim.SetFloat("Speed", param_value);

            if(moveDirection.magnitude > 0.2f)
            {
                walk_time += Time.deltaTime;

                if (walk_time > 0.4f)
                {
                    runningSound.Play();
                    walk_time = 0f;
                }
                    
            }
                

            if (Input.GetButton("Jump") && !restrict_movement)
            {
                moveDirection.y = jumpSpeed;
                anim.SetTrigger("PlayerJump");
            }
        }
        else
        {
            anim.SetBool("Grounded", false);
        }

        // Apply gravity. Gravity is multiplied by deltaTime twice (once here, and once below
        // when the moveDirection is multiplied by deltaTime). This is because gravity should be applied
        // as an acceleration (ms^-2)
        moveDirection.y -= gravity * Time.deltaTime;

        // Move the controller
        characterController.Move(moveDirection * Time.deltaTime);
    }
    
    public Vector3 GetMovementVector()
    {
        return moveDirection;
    }
}
