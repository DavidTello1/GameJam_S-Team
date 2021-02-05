using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerWin : MonoBehaviour
{
    public GameObject winMenu; // pases el menu win
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            Debug.Log("Next Level");

            if (winMenu != null)
            {
                winMenu.SetActive(true);
            }
            else
            {

                LevelManager.NextLevel();
            }
            
        }
    }
}
