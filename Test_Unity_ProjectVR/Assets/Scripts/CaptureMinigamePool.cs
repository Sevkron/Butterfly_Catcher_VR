using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CaptureMinigamePool : MonoBehaviour
{
    public GameObject[] sphDifficulty0;
    public GameObject[] sphDifficulty1;
    public GameObject[] sphDifficulty2;
    public GameObject[] sphDifficulty3;

    private GameObject[] sphDifficulty;
    // Start is called before the first frame update
    void Awake()
    {
        
    }

    public void SpawnSph(int difficulty)
    {
        switch(difficulty)
        {
            case 0:
            sphDifficulty = sphDifficulty0;
            break;
            case 1:
            sphDifficulty = sphDifficulty1;
            break;
            case 2:
            sphDifficulty = sphDifficulty2;
            break;
            case 3:
            sphDifficulty = sphDifficulty3;
            break;
            default:
            sphDifficulty = sphDifficulty0;
            break;
        }

        int i = Random.Range(0, sphDifficulty.Length);

        if(sphDifficulty[i] == null)
            Debug.Log("No sphere minigame at asked difficulty level :" + i.ToString());
        else
            Instantiate(sphDifficulty[i], transform.parent, false);
    }
}
