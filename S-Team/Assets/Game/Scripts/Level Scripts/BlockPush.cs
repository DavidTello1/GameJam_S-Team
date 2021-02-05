using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BlockPush : MonoBehaviour
{
    private bool grounded = true;
    private float pos_x = 0.0f;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (grounded == true && transform.position.y < -0.74f)
        {
            pos_x = transform.position.x;
            grounded = false;
        }
        else if (grounded == false)
        {
            transform.position = new Vector3(pos_x, transform.position.y, transform.position.z);
            gameObject.GetComponent<Rigidbody>().drag = 5;
        }
    }
}
