using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RespawnTechLevel : MonoBehaviour
{
    public int current_checkpoint = 1;

    [Header("Spawns")]
    public GameObject SpawnPoint_1;
    public GameObject SpawnPoint_2;
    public GameObject SpawnPoint_3;

    GameObject player_manager;

    // Start is called before the first frame update
    void Start()
    {
        player_manager = GameObject.Find("PlayersManager");
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            if (current_checkpoint == 1)
                player_manager.GetComponent<PlayerManager>().RespawnPlayer(SpawnPoint_1.transform);
            else if (current_checkpoint == 2)
                player_manager.GetComponent<PlayerManager>().RespawnPlayer(SpawnPoint_2.transform);
            else if (current_checkpoint == 3)
                player_manager.GetComponent<PlayerManager>().RespawnPlayer(SpawnPoint_3.transform);
        }
    }
}
