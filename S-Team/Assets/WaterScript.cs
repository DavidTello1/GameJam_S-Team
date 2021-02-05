using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterScript : MonoBehaviour
{
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
            
            //var player = other.gameObject.GetComponent<PlayerScientist>();
            if (other.bounds.center.y < -2.1f)
            {
                LevelManager.RestartLevel();
                Debug.Log("playerDead");
            }
        }
    }
}
