using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TechScript : MonoBehaviour
{
    public GameObject TechGame;
    public TechManager tech_manager;

    public float speed = 0.1f;
    public GameObject platform;

    GameObject player_manager;
    GameObject player;

    // Start is called before the first frame update
    void Start()
    {
        player_manager = GameObject.Find("PlayersManager");
    }

    // Update is called once per frame
    void Update()
    {
        if (tech_manager.completed)
        {
            //Task Completed SFX
            if (TechGame.activeInHierarchy)
            {
                foreach (GameObject cell in tech_manager.cells)
                {
                    if (cell.GetComponent<Cell>().is_node == false)
                        cell.GetComponent<Image>().color = Color.black;
                }
                TechGame.SetActive(false);
            }

            if (platform.transform.position.x > 11.75f)
            {
                platform.transform.position = new Vector3(platform.transform.position.x - speed, platform.transform.position.y, platform.transform.position.z);
            }
            else
            {
                player.GetComponent<Movement>().restrict_movement = false;
                gameObject.SetActive(false);
            }
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player") && player_manager.GetComponent<PlayerManager>().GetActivePlayer() == 1)
        {
            player = other.gameObject;
            TechGame.SetActive(true);
            player.GetComponent<Movement>().restrict_movement = true;
        }
    }

    public void OnReturnButtonClicked()
    {
        if (TechGame.activeInHierarchy)
        {
            foreach (GameObject cell in tech_manager.cells)
            {
                if (cell.GetComponent<Cell>().is_node == false)
                    cell.GetComponent<Image>().color = Color.black;
            }
            player.GetComponent<Movement>().restrict_movement = false;
            TechGame.SetActive(false);
        }
    }
}