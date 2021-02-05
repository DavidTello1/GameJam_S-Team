using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TechManager : MonoBehaviour
{
    public Transform FirstCellPos;
    public GameObject BackGround;
    public GameObject CellPrefab;

    public int grid_size = 5;
    public int cell_size = 78;
    public Color current_color = Color.white;
    public List<GameObject> cells;

    public Vector2 node1_start;
    public Vector2 node1_end;
    public Vector2 node2_start;
    public Vector2 node2_end;

    // Start is called before the first frame update
    void Start()
    {
        for (uint i = 0; i < grid_size; ++i)
        {
            for (uint j = 0; j < grid_size; ++j)
            {
                Vector3 pos = new Vector3(FirstCellPos.position.x + cell_size * i, FirstCellPos.position.y - cell_size * j, FirstCellPos.position.z);
                GameObject cell = Instantiate(CellPrefab, pos, Quaternion.identity, this.transform);
                cells.Add(cell);

                Vector2 current_pos = new Vector2(i, j);
                cell.GetComponent<Image>().color = Color.white;
                cell.GetComponent<Cell>().pos = current_pos;

                Debug.Log(current_pos);
                if (current_pos == node1_start || current_pos == node1_end)
                {
                    Debug.Log("Is Node");
                    cell.GetComponent<Cell>().is_node = true;
                    cell.GetComponent<Image>().color = Color.red;
                }
                else if (current_pos == node2_start || current_pos == node2_end)
                {
                    cell.GetComponent<Cell>().is_node = true;
                    cell.GetComponent<Image>().color = Color.blue;
                }
            }
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
