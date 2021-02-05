using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BlockPush : MonoBehaviour
{
    public GameObject floor;

    bool grounded = true;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        // if (collision with floor == false)
        //     grounded = false;

        if (grounded == false)
            gameObject.GetComponent<Rigidbody>().drag = 5;
    }
}
