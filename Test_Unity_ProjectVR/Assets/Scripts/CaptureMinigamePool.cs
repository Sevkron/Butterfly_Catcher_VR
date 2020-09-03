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

    private MeshRenderer butterflyMeshRenderer;
    private SkinnedMeshRenderer[] butterflySkinnedMeshRenderers;
    public bool testSphereSpawn;
    public int difficultyLevel;
    public GameObject currentButterfly;

    public GameObject m_captureModeSphere;
    public ParticleSystem m_capWinVFX;
    public bool isNotInMinigame = true;

    public Transform headTransform;
    public Transform beltTransform;
    public Transform spawnPoint;

    private AudioManager audioManager;
    public GameObject m_CountdownCanvas;
    //test Sphere spawn

    void Start()
    {
        audioManager = FindObjectOfType<AudioManager>();
    }
    void Update()
    {
        if(testSphereSpawn)
            SpawnSph(null);
            testSphereSpawn = false;
    }

    public void SpawnSph(GameObject butterfly)
    {
        m_captureModeSphere.SetActive(true);

        butterflyMeshRenderer = butterfly.GetComponentInChildren<MeshRenderer>();
        butterflySkinnedMeshRenderers = butterfly.GetComponentsInChildren<SkinnedMeshRenderer>();
        butterflyMeshRenderer.enabled = false;
        for(int m = 0; m < butterflySkinnedMeshRenderers.Length; m++)
        {
            butterflySkinnedMeshRenderers[m].enabled = false;
        }

        isNotInMinigame = false;
        int difficulty = butterfly.GetComponent<YMovement>().difficultyLevel;
        currentButterfly = butterfly;
        switch(difficulty)
        {
            case 0:
            sphDifficulty = sphDifficulty0;
            Debug.Log("spawn sphere difficulty 0");
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
        //T'es le meilleur !

        int i = Random.Range(0, sphDifficulty.Length);
        //Debug.Log("Array list is of : " + sphDifficulty.Length);
        //Debug.Log("Spawn minigame number" + i);

        if(sphDifficulty[i] == null)
            Debug.Log("No sphere minigame at asked difficulty level :" + i.ToString());
        else
            //Instantiate(sphDifficulty[i], transform, false);
            Instantiate(sphDifficulty[i], spawnPoint.position, spawnPoint.rotation, null);
            
    }

    public void FreeButterfly()
    {
        m_captureModeSphere.GetComponent<Animator>().SetTrigger("Close");
        m_captureModeSphere.SetActive(false); // Here too
        isNotInMinigame = true;
        Destroy(currentButterfly.transform.parent.gameObject);
    }

    public void CaughtButterfly()
    {
        butterflyMeshRenderer.enabled = true;
        for(int m = 0; m < butterflySkinnedMeshRenderers.Length; m++)
        {
            butterflySkinnedMeshRenderers[m].enabled = true;
        }
        isNotInMinigame = true;
        m_capWinVFX.Play();
        m_captureModeSphere.GetComponent<Animator>().SetTrigger("Close");
        m_captureModeSphere.SetActive(false); //Need top modify this for the animation to play out
    }

    public void PlaySound(string SoundToPlay)
    {
        audioManager.Play(SoundToPlay, null);
        Debug.Log("Play sound" + SoundToPlay);
    }
}
