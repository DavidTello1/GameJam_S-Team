using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameController : MonoBehaviour
{
    static GameController instance;

    private void Awake()
    {
        // Very first time game controller is instantiated
        if (instance == null)
        {
            instance = this;
            LevelManager.Init();
            DontDestroyOnLoad(this);

        }
        else
        {
            Destroy(this);
        }
    }

    public void MainMenuPlay(int level)
    {
        LevelManager.current_level = level;
        LevelManager.LoadLevel();
        Debug.Log("Entering level" + level.ToString());
    }


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        LevelManager.Update();
    }
}
