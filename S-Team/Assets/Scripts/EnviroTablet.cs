using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class EnviroTablet : MonoBehaviour
{
    public string correct_answer;
    public InputField input;

    public bool correct = false;

    GameObject player;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return) && input.gameObject.activeInHierarchy)
        {
            input.text = "";
            player.GetComponent<Movement>().restrict_movement = false;
            input.gameObject.SetActive(false);
        }

        if(input.text == correct_answer)
        {
            correct = true;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player") && !correct)
        {
            input.gameObject.SetActive(true);
            player = other.gameObject;
            player.GetComponent<Movement>().restrict_movement = true;
        }
        
    }
}
