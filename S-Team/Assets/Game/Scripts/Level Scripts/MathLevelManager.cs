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

    public GameObject tablet;
    public GameObject plate;

    public Material mat;

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
        if(plate.GetComponent<PressurePlate>().pressed)
        {
            foreach (Renderer rend in rendererList_L)
                rend.material = emissiveMat;
        }

        if (tablet.GetComponent<EnviroTablet>().correct)
        {
            foreach (Renderer rend in rendererList_R)
                rend.material = emissiveMat;
        }

        if(plate.GetComponent<PressurePlate>().pressed && tablet.GetComponent<EnviroTablet>().correct)
        {
            GameObject.Find("Door").GetComponent<Renderer>().material = mat;
            GameObject.Find("WinCollider").GetComponent<BoxCollider>().isTrigger = true;
        }
    }
}
