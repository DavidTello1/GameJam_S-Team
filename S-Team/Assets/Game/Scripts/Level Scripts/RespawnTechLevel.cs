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

    // Start is called before the first frame update
    void Start()
    {
        
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
                other.gameObject.transform.position = SpawnPoint_1.transform.position;
            else if (current_checkpoint == 2)
                other.gameObject.transform.position = SpawnPoint_2.transform.position;
            else if (current_checkpoint == 3)
                other.gameObject.transform.position = SpawnPoint_3.transform.position;
        }
    }
}
