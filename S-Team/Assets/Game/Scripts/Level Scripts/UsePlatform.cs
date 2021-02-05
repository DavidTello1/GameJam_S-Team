using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UsePlatform : MonoBehaviour
{
    public bool interact = false;
    public float speed = 0.1f;

    public GameObject platform;
    GameObject player;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if (interact)
        {
            platform.transform.position = new Vector3(platform.transform.position.x + speed, platform.transform.position.y, platform.transform.position.z);
            player.transform.position = new Vector3(player.transform.position.x + speed, player.transform.position.y, player.transform.position.z);

            if (platform.transform.position.x >= 33.5f)
            {
                player.GetComponent<Movement>().restrict_movement = false;
                gameObject.SetActive(false);
            }
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            interact = true; ;
            player = other.gameObject;
            player.GetComponent<Movement>().restrict_movement = true;
        }
    }
}