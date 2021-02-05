using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class Cell : MonoBehaviour
{
    public bool is_node;
    public Vector2 pos;
    public Vector2 prev_cell;
    public Vector2 next_cell;

    private TechManager tech_manager;

    // Start is called before the first frame update
    void Start()
    {
        tech_manager = transform.parent.gameObject.GetComponent<TechManager>();
    }

    // Update is called once per frame
    void Update()
    {
    }

    public void SelectCell()
    {
        if (Input.GetMouseButtonDown(0))
        {
            if (is_node)
                tech_manager.current_color = GetComponent<Image>().color;
            else
                tech_manager.current_color = Color.white;
        }

        if (Input.GetMouseButton(0))
        {
            if (!is_node)
                GetComponent<Image>().color = tech_manager.current_color;
        }
    }
    
    public void ClearPath()
    {
        //if (Input.GetMouseButton(0) && !is_node)
        //{
            tech_manager.current_color = Color.white;
            foreach (GameObject cell in tech_manager.cells)
            {
                if (cell.GetComponent<Image>().color == GetComponent<Image>().color && !cell.GetComponent<Cell>().is_node)
                {
                    cell.GetComponent<Image>().color = Color.white;
                    tech_manager.current_color = Color.white;
                }
            }
        //}
    }
}
