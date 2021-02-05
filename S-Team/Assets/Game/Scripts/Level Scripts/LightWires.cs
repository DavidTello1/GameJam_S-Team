using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightWires : MonoBehaviour
{
    public GameObject[] wires;
    public GameObject[] wires2;
    public Material light_mat;

    public Material winMat;

    bool done = false;
    bool done2 = false;

    // Update is called once per frame
    void Update()
    {
        if(gameObject.GetComponent<EnviroTablet>().correct && !done)
        {
            done = true;

            foreach(var wire in wires)
            {
                wire.GetComponent<Renderer>().material = light_mat;
            }
        }

        if (GameObject.Find("PressurePlate").GetComponent<PressurePlate>().pressed && !done2)
        {
            done2 = true;

            foreach (var wire in wires2)
            {
                wire.GetComponent<Renderer>().material = light_mat;
            }
        }

        if(done && done2)
        {
            GameObject.Find("Door").GetComponent<Renderer>().material = winMat;
            GameObject.Find("WinCollider").GetComponent<BoxCollider>().isTrigger = true;
        }
    }
}
