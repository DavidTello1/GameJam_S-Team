using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class Cell : MonoBehaviour
{
    public Vector2 pos;
    public Vector2 prev_cell;
    public Vector2 next_cell;

    private bool is_node;
    private TechManager tech_manager;

    // Start is called before the first frame update
    void Start()
    {
        tech_manager = transform.parent.gameObject.GetComponent<TechManager>();

        if (pos == tech_manager.node1_start || pos == tech_manager.node1_end)
        {
            is_node = true;
            GetComponent<Image>().color = Color.red;
        }
        else if (pos == tech_manager.node2_start || pos == tech_manager.node2_end)
        {
            is_node = true;
            GetComponent<Image>().color = Color.blue;
        }
        else
        {
            is_node = false;
            GetComponent<Image>().color = Color.white;
        }
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
            {
                tech_manager.current_color = GetComponent<Image>().color;
                foreach (GameObject cell in tech_manager.cells)
                {
                    if (cell.GetComponent<Image>().color == tech_manager.current_color && !cell.GetComponent<Cell>().is_node)
                        cell.GetComponent<Image>().color = Color.white;
                }

                if (GetComponent<Image>().color == Color.red)
                    tech_manager.color1_completed = false;
                else if (GetComponent<Image>().color == Color.blue)
                    tech_manager.color2_completed = false;
            }
            else
                tech_manager.current_color = Color.white;
        }

        if (Input.GetMouseButton(0))
        {
            if (is_node)
            {
                if (GetComponent<Image>().color != tech_manager.current_color)
                    ClearPath();
                //tech_manager.current_color = GetComponent<Image>().color;
            }
            else
            {
                if (GetComponent<Image>().color == Color.white)
                    GetComponent<Image>().color = tech_manager.current_color;
                else
                {
                    bool same_color = false;

                    if (GetComponent<Image>().color == tech_manager.current_color)
                        same_color = true;

                    Color color = tech_manager.current_color;
                    ClearPath();

                    if (!same_color)
                    {
                        tech_manager.current_color = color;
                        GetComponent<Image>().color = tech_manager.current_color;
                    }
                }
            }
        }
    }

    public void ClearPath()
    {
        Debug.Log(is_node);
        if (is_node)
        {
            if (GetComponent<Image>().color != tech_manager.current_color)
            {
                if (GetComponent<Image>().color == Color.red)
                    tech_manager.color1_completed = false;
                else if (GetComponent<Image>().color == Color.blue)
                    tech_manager.color2_completed = false;

                foreach (GameObject cell in tech_manager.cells)
                {
                    if (cell.GetComponent<Image>().color == tech_manager.current_color && !cell.GetComponent<Cell>().is_node)
                        cell.GetComponent<Image>().color = Color.white;
                }
            }
            else
            {
                if (GetComponent<Image>().color == Color.red)
                    tech_manager.color1_completed = true;
                else if (GetComponent<Image>().color == Color.blue)
                    tech_manager.color2_completed = true;
            }
        }
        else
        {
            if (GetComponent<Image>().color == Color.red)
                tech_manager.color1_completed = false;
            else if (GetComponent<Image>().color == Color.blue)
                tech_manager.color2_completed = false;

            foreach (GameObject cell in tech_manager.cells)
            {
                if (cell != gameObject && cell.GetComponent<Image>().color == GetComponent<Image>().color && !cell.GetComponent<Cell>().is_node)
                    cell.GetComponent<Image>().color = Color.white;
            }
            GetComponent<Image>().color = Color.white;
        }
        tech_manager.current_color = Color.white;
    }
}
