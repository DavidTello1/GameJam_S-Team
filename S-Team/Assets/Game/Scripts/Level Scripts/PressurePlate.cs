using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PressurePlate : MonoBehaviour
{
    // Start is called before the first frame update
    public float timer;
    public bool pressed = false;

    private float stayTime = 2.0f;
    private bool start_timer = false;
    // Update is called once per frame
    void Update()
    {
        if (start_timer)
            timer += Time.deltaTime;

        if(timer > stayTime)
        {
            pressed = true;
            start_timer = false;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
            start_timer = true;
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
            start_timer = false;
    }
}
