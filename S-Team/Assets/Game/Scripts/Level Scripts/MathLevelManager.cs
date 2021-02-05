using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MathLevelManager : MonoBehaviour
{
    public GameObject[] lightStrips_R;
    public GameObject[] lightStrips_L;
    IList<Renderer> rendererList_R = new List<Renderer>();
    IList<Renderer> rendererList_L = new List<Renderer>();
    public Material baseMat;
    public Material emissiveMat;

    private bool problemDone = false;
    private bool pressurePlatePressed = false;

    // Start is called before the first frame update
    void Start()
    {
        foreach (GameObject gos in lightStrips_R)
        {
            rendererList_R.Add(gos.gameObject.GetComponent<Renderer>());
        }

        foreach (GameObject gos in lightStrips_L)
        {
            rendererList_L.Add(gos.gameObject.GetComponent<Renderer>());
        }
    }

    // Update is called once per frame
    void Update()
    {
        if(pressurePlatePressed)
        {
            foreach (Renderer rend in rendererList_L)
                rend.material = emissiveMat;
        }

        if (problemDone)
        {
            foreach (Renderer rend in rendererList_R)
                rend.material = emissiveMat;
        }

        if (Input.GetKeyDown(KeyCode.G))
        {
            pressurePlatePressed = !pressurePlatePressed;
        }

        if (Input.GetKeyDown(KeyCode.H))
        {
            problemDone = !problemDone;
        }
    }
}
