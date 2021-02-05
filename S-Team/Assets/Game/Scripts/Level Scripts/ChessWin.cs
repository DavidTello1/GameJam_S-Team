using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChessWin : MonoBehaviour
{
    // Start is called before the first frame update
    public float timer;
    private float stayTime = 2.0f;
    private bool start_timer = false;

    public Material WinMaterial;

    bool level_completed = false;
    float slider_value = 0.0f;

    Renderer king_renderer;

    private void Start()
    {
        king_renderer = GameObject.Find("KingDark").GetComponent<Renderer>();
    }
    // Update is called once per frame
    void Update()
    {
        if (start_timer)
            timer += Time.deltaTime;

        if(timer > stayTime)
        {
            //Code to change to lvl2 here
            level_completed = true;
            start_timer = false;
        }

        if(level_completed)
        {
            if (slider_value < 1)
            {
                slider_value += 0.25f * Time.deltaTime;

                if (slider_value > 1)
                    slider_value = 1;
            }
            else
            {
                GameObject.Find("Door").GetComponent<Renderer>().material = WinMaterial;
                GameObject.Find("WinCollider").GetComponent<BoxCollider>().isTrigger = true;
            }

            king_renderer.material.SetFloat("_Dissolve", slider_value);
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
