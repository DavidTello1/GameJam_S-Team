using System.Collections;
using System.Collections.Generic;
using UnityEngine;

enum ActivePlayer
{
    Green = 0,
    Orange, 
    Yellow,
    Purple,
    Blue
}

public class PlayerManager : MonoBehaviour
{
    public GameObject green;
    public GameObject orange;
    public GameObject yellow;
    public GameObject purple;
    public GameObject blue;

    GameObject active;
    ActivePlayer player;
    Vector3 position;
    Quaternion rotation;

    public GameObject camera;

    // Start is called before the first frame update
    void Start()
    {
        active = GameObject.Instantiate(green, Vector3.zero, Quaternion.identity);
        player = ActivePlayer.Green;

        camera.GetComponent<FollowCamera>().target = active.transform;

        position = Vector3.zero;
        rotation = Quaternion.identity;
    }

    // Update is called once per frame
    void Update()
    {
        position = active.transform.position;
        rotation = active.transform.rotation;

        if(Input.GetKeyDown(KeyCode.Alpha1))
        {
            if(player != ActivePlayer.Green)
            {
                //Destroy active player
                string name = ReturnName((int)player);
                GameObject.Destroy(GameObject.Find(name));

                //Instantiate new player
                active = GameObject.Instantiate(green, position, rotation);
                camera.GetComponent<FollowCamera>().target = active.transform;
                player = ActivePlayer.Green;
            }
            
        }
        else if(Input.GetKeyDown(KeyCode.Alpha2))
        {
            if (player != ActivePlayer.Orange)
            {
                //Destroy active player
                string name = ReturnName((int)player);
                GameObject.Destroy(GameObject.Find(name));

                //Instantiate new player
                active = GameObject.Instantiate(orange, position, rotation);
                camera.GetComponent<FollowCamera>().target = active.transform;
                player = ActivePlayer.Orange;
            }
        }
        else if (Input.GetKeyDown(KeyCode.Alpha3))
        {
            if (player != ActivePlayer.Yellow)
            {
                //Destroy active player
                string name = ReturnName((int)player);
                GameObject.Destroy(GameObject.Find(name));

                //Instantiate new player
                active = GameObject.Instantiate(yellow, position, rotation);
                camera.GetComponent<FollowCamera>().target = active.transform;
                player = ActivePlayer.Yellow;
            }
        }
        else if (Input.GetKeyDown(KeyCode.Alpha4))
        {
            if (player != ActivePlayer.Purple)
            {
                //Destroy active player
                string name = ReturnName((int)player);
                GameObject.Destroy(GameObject.Find(name));

                //Instantiate new player
                active = GameObject.Instantiate(purple, position, rotation);
                camera.GetComponent<FollowCamera>().target = active.transform;
                player = ActivePlayer.Purple;
            }
        }
        else if (Input.GetKeyDown(KeyCode.Alpha5))
        {
            if (player != ActivePlayer.Blue)
            {
                //Destroy active player
                string name = ReturnName((int)player);
                GameObject.Destroy(GameObject.Find(name));

                //Instantiate new player
                active = GameObject.Instantiate(blue, position, rotation);
                camera.GetComponent<FollowCamera>().target = active.transform;
                player = ActivePlayer.Blue;
            }
        }
    }

    string ReturnName(int active_player)
    {
        string name = "";

        switch(active_player)
        {
            case 0:
                name = "ScienceFemale Variant(Clone)";
                break;
            case 1:
                name = "TechFemale Variant(Clone)";
                break;
            case 2:
                name = "EngineFemale Variant(Clone)";
                break;
            case 3:
                name = "ArtFemale Variant(Clone)";
                break;
            case 4:
                name = "MathFemale Variant(Clone)";
                break;
        }

        return name;
    }

    public int GetActivePlayer()
    {
        return (int)player;
    }
}
