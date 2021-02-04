using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChessWin : MonoBehaviour
{
    // Start is called before the first frame update
    public float timer;
    private float stayTime = 15.0f;
    private bool start_timer = false;
    // Update is called once per frame
    void Update()
    {
        if (start_timer)
            timer += Time.deltaTime;

        if(timer > stayTime)
        {
            //Code to change to lvl2 here
            Debug.Log("Change scene");
            start_timer = false;
        }
          
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer == LayerMask.NameToLayer("MovableCube"))
        {
            start_timer = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.layer == LayerMask.NameToLayer("MovableCube"))
            start_timer = false;
    }
}
