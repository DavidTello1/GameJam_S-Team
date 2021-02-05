using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EngineerPush : MonoBehaviour
{

    [Header("Pushing properties")]
    [Tooltip("The force that allows players to push the cube")]
    public float pushForce = 10.0f;
    [Tooltip("Player's movement script")]
    public Movement playerMove;
    [Tooltip("Conditional to control player touching a cube")]
    public bool isPushing = false;

    Animator anim;

    void Start()
    {
        playerMove = GetComponent<Movement>();
        anim = GetComponent<Animator>();
    }

    void Update()
    {
        // Raycast to detect MovableCube and collides only with this layer
        int layerMask = 1 << 8;

        RaycastHit hit;

        if (Physics.Raycast(transform.position, transform.forward, out hit, 0.75f, layerMask))
        {
            if(hit.distance > 0.1)
            {
                isPushing = true;
                anim.SetBool("Push", true);
                anim.SetTrigger("PushEvent");
                Debug.DrawRay(transform.position, transform.TransformDirection(Vector3.forward) * hit.distance, Color.green);
            }
        }
        else
        {
            isPushing = false;
            anim.SetBool("Push", false);
            Debug.DrawRay(transform.position, transform.TransformDirection(Vector3.forward) * 100, Color.red);
        }
            
    }

    void OnControllerColliderHit(ControllerColliderHit hit)
    {
        if(isPushing)
        {
            Rigidbody body = hit.collider.attachedRigidbody;
            if (body == null || body.isKinematic || (hit.moveDirection.y < -0.3f))
                return;

            Vector3 pushDir = new Vector3(hit.moveDirection.x, 0, hit.moveDirection.z);

            body.velocity = pushDir * pushForce;
        }
    }
}
