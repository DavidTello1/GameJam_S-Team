using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightUp : MonoBehaviour
{
    Renderer lightRenderer;
    public Material baseMat;
    public Material emissiveMat;
    // Start is called before the first frame update
    void Start()
    {
        lightRenderer = GetComponent<Renderer>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.G))
        {
            lightRenderer.material = emissiveMat;
            Debug.Log("Emissive");
        }

        if (Input.GetKeyDown(KeyCode.H))
        {
            Debug.Log("Base");
            lightRenderer.material = baseMat;
        }
    }
}
