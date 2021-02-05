using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerWin : MonoBehaviour
{
    public GameObject winMenu; // pases el menu win
    private AudioSource winSound;

    private void Awake()
    {
        winSound = GetComponent<AudioSource>();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            Debug.Log("Next Level");

            if (winSound)
                winSound.Play();

            if (winMenu != null)
            {
                winMenu.SetActive(true);
                other.gameObject.GetComponent<Movement>().restrict_movement = true;
            }
            else
            {
                LevelManager.NextLevel();
            }
            
        }
    }
}
