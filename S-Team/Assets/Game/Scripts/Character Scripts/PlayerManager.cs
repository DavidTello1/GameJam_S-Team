using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

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

    [Header("UI Icons")]
    public Image science;
    public Image tech;
    public Image engine;
    public Image art;
    public Image math;

    GameObject active;
    ActivePlayer player;
    Vector3 position;
    Quaternion rotation;

    [Header("Camera")]
    public GameObject camera;

    // Start is called before the first frame update
    void Start()
    {
        active = GameObject.Instantiate(green, Vector3.zero, Quaternion.identity);
        player = ActivePlayer.Green;
        SetActiveUI((int)player);

        camera.GetComponent<FollowCamera>().target = active.transform;

        position = Vector3.zero;
        rotation = Quaternion.identity;
    }

    // Update is called once per frame
    void Update()
    {
        position = active.transform.position;
        rotation = active.transform.rotation;

        if (active.GetComponent<Movement>().restrict_movement)
            return;

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
                SetActiveUI((int)player);
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
                SetActiveUI((int)player);
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
                SetActiveUI((int)player);
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
                SetActiveUI((int)player);
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
                SetActiveUI((int)player);
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

    void SetActiveUI(int player)
    {
        Color white = new Color(1f, 1f, 1f, 1f);
        Color dark = new Color(0.5f, 0.5f, 0.5f, 1f);

        switch (player) //138
        {
            case (int)ActivePlayer.Green:
                science.color = white;
                tech.color = dark;
                engine.color = dark;
                art.color = dark;
                math.color = dark;
                break;
            case (int)ActivePlayer.Orange:
                science.color = dark;
                tech.color = white;
                engine.color = dark;
                art.color = dark;
                math.color = dark;
                break;
            case (int)ActivePlayer.Yellow:
                science.color = dark;
                tech.color = dark;
                engine.color = white;
                art.color = dark;
                math.color = dark;
                break;
            case (int)ActivePlayer.Purple:
                science.color = dark;
                tech.color = dark;
                engine.color = dark;
                art.color = white;
                math.color = dark;
                break;
            case (int)ActivePlayer.Blue:
                science.color = dark;
                tech.color = dark;
                engine.color = dark;
                art.color = dark;
                math.color = white;
                break;
        }
    }
}