using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ArtistCanvas3DVoxel : MonoBehaviour
{
    public static Material m_white;
    public static Material m_black;
    private MeshRenderer renderer;

    public bool white = false;
    private void Awake()
    {
        white = false;
        renderer = GetComponent<MeshRenderer>();

        m_black = Resources.Load<Material>("Materials/CharacterArtistMaterials/Black");
        m_white = Resources.Load<Material>("Materials/CharacterArtistMaterials/White");
        renderer.material = m_black;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void OnClick()
    {
        renderer.material = white ? m_black : m_white;
        white = !white;
    }
}
