using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;


public enum FadeState
{
    ToWhite,
    ToBlack,

    Idle
}

public static class LevelManager
{
    public static int current_level = 0;

    // Transitioning
    public static FadeState state = FadeState.Idle;
    public static Image fadeToBlackImage;

    private static float time = 0;
    private static float transitionTime = 2.0f;
    private static float timeStep = 0.0f;

    static Color black0 = Color.black;
    static Color black1 = Color.black;

    public static void Init()
    {
        CreateFadeImage();
        black0 = new Color(0, 0, 0, 0);
        black1 = new Color(0, 0, 0, 1);

        timeStep = 1.0f / transitionTime;

        SceneManager.sceneLoaded += OnSceneLoaded;

    }

    private static void CreateFadeImage()
    {
        if (fadeToBlackImage != null) return;
        GameObject fadeToBlackCanvas = Resources.Load<GameObject>("FadeToBlackCanvas");
        fadeToBlackImage = GameObject.Instantiate(fadeToBlackCanvas).GetComponentInChildren<Image>();
    }

    // Loads level "level" or Restarts the current level if not argument passed 
    public static void LoadLevel(int level = -1)
    {
        current_level = level > -1 ? level : current_level; 
        FadeToBlack();
    }
    
    
    public static void Update()
    {
        time += timeStep * Time.deltaTime;

        switch (state)
        {
            case FadeState.ToWhite:
                fadeToBlackImage.color = Color.Lerp(black1, black0, time);
                break;
            case FadeState.ToBlack:
                fadeToBlackImage.color = Color.Lerp(black0, black1, time);
                break;
            case FadeState.Idle:
                break;
        }

        // Transition has finished
        if (time > 1)
        {
            switch (state)
            {
                case FadeState.ToBlack:
                    SceneManager.LoadScene(current_level);
                    break;
                default:
                    state = FadeState.Idle;
                    break;
            }
        }
    }
    public static void RestartLevel()
    {
        LoadLevel();
    }

    public static void NextLevel()
    {
        ++current_level;
        LoadLevel();
    }

    public static void PreviousLevel()
    {
        --current_level;
        LoadLevel();
    }

    public static void OnSceneLoaded(Scene scene, LoadSceneMode mode)
    {
        CreateFadeImage();
        FadeToWhite();
    }

    static void FadeToBlack()
    {
        state = FadeState.ToBlack;
        time = 0;
    }

    static void FadeToWhite()
    {
        state = FadeState.ToWhite;
        time = 0;
    }
}
