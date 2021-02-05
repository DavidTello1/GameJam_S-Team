using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class EnviroText : MonoBehaviour
{
    public string operation;
    string default_text;

    public TMP_FontAsset runic;
    public TMP_FontAsset _default;

    public GameObject playermanager;
    PlayerManager PM;
    TextMeshPro textMesh;

    // Start is called before the first frame update
    void Start()
    {
        PM = playermanager.GetComponent<PlayerManager>();
        textMesh = GetComponent<TextMeshPro>();
        default_text = textMesh.text;

    }

    // Update is called once per frame
    void Update()
    {
       if(PM.GetActivePlayer() == 4)
       {
            if(textMesh.text != operation)
            {
                textMesh.font = _default;
                textMesh.text = operation;
            }
               
       }
       else
       {
            if (textMesh.text != default_text)
            {
                textMesh.font = runic;
                textMesh.text = default_text;
            }
       }
    }
}
