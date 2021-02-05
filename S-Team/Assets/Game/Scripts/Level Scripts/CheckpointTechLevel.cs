using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckpointTechLevel : MonoBehaviour
{
    public int checkpoint = 1;
    public RespawnTechLevel lava_floor;

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
            if (checkpoint > lava_floor.current_checkpoint)
                lava_floor.current_checkpoint = checkpoint;
        }
    }
}
