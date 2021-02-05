using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PressurePlate : MonoBehaviour
{
    // Start is called before the first frame update
    public float timer;
    public bool pressed = false;
    public PlayerScientist playerScience;

    private float stayTime = 3.0f;
    private bool start_timer = false;
    private bool found = false;

    // Update is called once per frame
    void Update()
    {
        playerScience = GameObject.Find("ScienceFemale Variant(Clone)").GetComponent<PlayerScientist>();

        if (start_timer && !pressed)
            timer += Time.deltaTime;

        if(timer > stayTime)
        {
            pressed = true;
            start_timer = false;
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.gameObject.CompareTag("Player") && playerScience.currentSize == 2.0f)
            start_timer = true;
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
            start_timer = false;
    }
}
