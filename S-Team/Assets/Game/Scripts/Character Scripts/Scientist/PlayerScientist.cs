using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class PlayerScientist : MonoBehaviour
{
    public float maxSize = 2.0f;
    public float minSize = 0.5f;
    public float currentSize = 1.0f;

    private Vector3 last_size = Vector3.one;

    private float time = 0;
    private float transition_time = 2.0f;
    private float time_step = 0.0f;

    private void Start()
    {
        time_step = 1.0f / transition_time;
    }

    void Update()
    {
        time += time_step * Time.deltaTime;

        if (Input.GetKeyDown(KeyCode.Q))
        {
            last_size = transform.localScale;
            time = 0;
            GetComponent<Movement>().restrict_movement = true;
            // Is grown -> idle
            if (currentSize > 1.0f)
            {
                currentSize = 1.0f; // To idle == 1
            }
            // Is idle -> shrink
            else if (Mathf.Approximately(currentSize, 1.0f))
            {
                currentSize = 0.5f;
            }
        }
        else if (Input.GetKeyDown(KeyCode.E))
        {
            last_size = transform.localScale;
            time = 0;
            GetComponent<Movement>().restrict_movement = true;

            // Is shrinked -> idle
            if (currentSize < 1.0f)
            {
                currentSize = 1.0f; // To idle == 1
            }
            // Is idle -> grow
            else if (Mathf.Approximately(currentSize,1.0f))
            {
                currentSize = 2.0f;
            }
        }

        if (time > 1.0f)
            GetComponent<Movement>().restrict_movement = false;


    }

    private void FixedUpdate()
    {
        transform.localScale = Vector3.Lerp(last_size, new Vector3(currentSize, currentSize, currentSize), time);
    }

    private void Shrink()
    {

    }

    private void Grow()
    {

    }

}
