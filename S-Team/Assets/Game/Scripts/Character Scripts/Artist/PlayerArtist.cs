using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerArtist : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        //Debug.DrawLine(ray.origin, ray.origin + ray.direction * 50, Color.red);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit, 500f, LayerMask.GetMask("CanvasArtist3DLayer")))
        {
            if (Input.GetMouseButtonDown(0))
            {
                GameObject voxel = hit.collider.gameObject;
                //Debug.Log(voxel.name);

                voxel.GetComponent<ArtistCanvas3DVoxel>().OnClick();


            }
        }

    }
}
