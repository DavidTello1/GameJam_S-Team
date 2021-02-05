using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TechManager : MonoBehaviour
{
    public bool completed = false;

    public Color current_color = Color.white;
    public List<GameObject> cells;

    public int nodes = 2;
    public bool color1_completed = false;
    public bool color2_completed = false;
    public bool color3_completed = false;
    public bool color4_completed = false;

    public Vector2 node1_start;
    public Vector2 node1_end;
    public Vector2 node2_start;
    public Vector2 node2_end;
    public Vector2 node3_start;
    public Vector2 node3_end;
    public Vector2 node4_start;
    public Vector2 node4_end;

    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        if (nodes == 2 && color1_completed && color2_completed)
            completed = true;
        else if (nodes == 3 && color1_completed && color2_completed && color3_completed)
            completed = true;
        else if (nodes == 4 && color1_completed && color2_completed && color3_completed && color4_completed)
            completed = true;
    }
}
