using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TechScript : MonoBehaviour
{
    public GameObject TechGame;
    public TechManager tech_manager;
    GameObject player;

    public bool correct = false;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return) && TechGame.activeInHierarchy)
        {
            foreach (GameObject cell in tech_manager.cells)
            {
                if (cell.GetComponent<Cell>().is_node == false)
                    cell.GetComponent<Image>().color = Color.white;
            }
            player.GetComponent<Movement>().restrict_movement = false;
            TechGame.SetActive(false);
        }

        if (tech_manager.completed)
            correct = true;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player") && !correct)
        {
            TechGame.SetActive(true);
            player = other.gameObject;
            player.GetComponent<Movement>().restrict_movement = true;
        }
    }
}