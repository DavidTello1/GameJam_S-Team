using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MainMenu : MonoBehaviour
{
    [Header("Main")]
    public GameObject Main;

    [Header("Levels")]
    public GameObject Levels;
    public int max_levels = 3;
    public int current_level = 1;
    public int last_completed = 0;
    public GameObject Level_1;
    public GameObject Level_2;
    public GameObject Level_3;
    public GameObject PrevButton;
    public GameObject NextButton;

    [Header("Controls")]
    public GameObject Controls;
    public GameObject MainControls;
    public GameObject PlayersControls;

    [Header("Credits")]
    public GameObject Credits;

    private GameObject current_panel;


    private void Awake()
    {
        current_panel = Main;
    }

    private void Start()
    {
        // GetLastLevelCompleted()
        current_level = last_completed + 1;
    }

    private void SetActivePanel(string activePanel)
    {
        Main.SetActive(activePanel.Equals(Main.name));
        Levels.SetActive(activePanel.Equals(Levels.name));
        Controls.SetActive(activePanel.Equals(Controls.name));
        Credits.SetActive(activePanel.Equals(Credits.name));
    }

    // --- MAIN MENU ---
    public void OnLevelsButtonClicked()
    {
        SetActivePanel(Levels.name);
        current_panel = Levels;
        if (current_level == 1)
            PrevButton.SetActive(false);
        else if (current_level >= max_levels)
        {
            current_level = max_levels;
            NextButton.SetActive(false);
        }
    }

    public void OnControlsButtonClicked()
    {
        SetActivePanel(Controls.name);
        current_panel = Controls;
    }

    public void OnCreditsButtonClicked()
    {
        SetActivePanel(Credits.name);
        current_panel = Credits;
    }

    // --- SHARED ---
    public void OnBackButtonClicked()
    {
        SetActivePanel(Main.name);
    }

    public void OnNextButtonClicked()
    {
        if (current_panel == Levels)
        {
            current_level++;
            SetLevelPreview(current_level);

            if (current_level >= max_levels && NextButton.activeSelf == true)
                NextButton.SetActive(false);

            if (PrevButton.activeSelf == false)
                PrevButton.SetActive(true);
        }
        else if (current_panel == Controls)
        {
            MainControls.SetActive(false);
            PlayersControls.SetActive(true);
        }
    }

    public void OnPreviousButtonClicked()
    {
        if (current_panel == Levels)
        {
            current_level--;
            SetLevelPreview(current_level);

            if (current_level <= 1 && PrevButton.activeSelf == true)
                PrevButton.SetActive(false);

            if (NextButton.activeSelf == false)
                NextButton.SetActive(true);
        }
        else if (current_panel == Controls)
        {
            MainControls.SetActive(true);
            PlayersControls.SetActive(false);
        }
    }

    // --- LEVELS ---
    public void OnPlayButtonClicked()
    {
        // LoadScene
    }

    private void SetLevelPreview(int level)
    {
        Level_1.SetActive(level.Equals(1));
        Level_2.SetActive(level.Equals(2));
        Level_3.SetActive(level.Equals(3));
    }
}