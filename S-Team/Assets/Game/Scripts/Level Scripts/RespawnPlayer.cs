using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RespawnPlayer : MonoBehaviour
{

    public Transform respawn;

    public GameObject PM;

    private void OnTriggerEnter(Collider collision)
    {
        if (collision.gameObject.CompareTag("Player"))
        {
            PM.GetComponent<PlayerManager>().RespawnPlayer(respawn);
        }
        
    }
}
