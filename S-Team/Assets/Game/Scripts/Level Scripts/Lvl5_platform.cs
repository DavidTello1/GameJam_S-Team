using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lvl5_platform : MonoBehaviour
{
    public GameObject TechManager;

    bool arrivedEnd = true;
    float speed = 0.01f;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (!TechManager.GetComponent<TechManager>().completed)
            return;
        if(arrivedEnd)
        {
            if (transform.position.z > -2.8f)
            {
                transform.position = new Vector3(transform.position.x, transform.position.y, transform.position.z - speed);
            }
            else
            {
                arrivedEnd = false;
            }
        }
        else
        {
            if (transform.position.z < 5.5f)
            {
                transform.position = new Vector3(transform.position.x, transform.position.y, transform.position.z + speed);
            }
            else
            {
                arrivedEnd = true;
            }
        }

    }
}
