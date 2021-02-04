using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum ArtistCanvasType
{
    STAIR,
    DOOR,

    ERROR
}

public class ArtistCanvas3D : MonoBehaviour
{
    private Figure figure;
    public ArtistCanvasType figure_type;
    public bool completed = false;


    private void Awake()
    {
        figure = new Figure(figure_type, transform);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void FixedUpdate()
    {
        CheckIfCompleted();
    }

    private void CheckIfCompleted()
    {
        if(!completed && figure.IsCorrect())
        {
            completed = true;
            Debug.Log("Figure completed!");
        }
    }

    public class Figure
    {
        ArtistCanvasType type = ArtistCanvasType.ERROR;

        bool[] door =
        {
            false, false, false,
            false, true, false,
            false, true, false
        };

        bool[] stairs1 =
        {
            true, false, false,
            true, true, false,
            true, true, true
        };

        bool[] stairs2 =
        {
            false, false, true,
            false, true, true,
            true, true, true
        };

        ArtistCanvas3DVoxel[] current_figure;
        public Figure(ArtistCanvasType type, Transform transform)
        {
            this.type = type;
            current_figure = new ArtistCanvas3DVoxel[9];
            for (int i=0; i<9; i++)
            {
                current_figure[i] = transform.GetChild(i).GetComponent<ArtistCanvas3DVoxel>();
            }
        }

        public bool IsCorrect()
        {
            switch (type)
            {
                case ArtistCanvasType.DOOR:
                    for (int i = 0; i < 9; i++)
                    {
                        if (current_figure[i].white != door[i])
                            return false;
                    }
                    return true;


                case ArtistCanvasType.STAIR:
                    bool correct = true;

                    for (int i = 0; i < 9 && correct; i++)
                    {
                        if (current_figure[i].white != stairs1[i])
                            correct = false;
                    }
                    if (correct)
                        return true;

                    for (int i = 0; i < 9; i++)
                    {
                        if (current_figure[i].white != stairs2[i])
                            return false;
                    }
                    return true;

                default:
                    Debug.LogError("Invalid figure in artist canvas 3D");
                    return false;
            }
        }

    }
}
