using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR.InteractionSystem ;

public class SpecialRockScript : MonoBehaviour
{
    public ItemPlacement m_itemPlacement1;
    public ItemPlacement m_itemPlacement2;
    public GameObject m_monsterButterflyGO;
    private bool hasActivatedOnce = false;
    private AudioManager audioManager;
    public List<Transform> m_spawnPositions;
    public GameObject[] m_theTwins;
    // Start is called before the first frame update
    void Awake()
    {
        audioManager = FindObjectOfType<AudioManager>();
        for(int i = 0; i < m_theTwins.Length; i++)
        {
            int index = Random.Range(0, m_spawnPositions.Count);
            m_theTwins[i].transform.position = m_spawnPositions[index].transform.position;
            m_spawnPositions.RemoveAt(index);
        }
    }

    // Update is called once per frame
    void Update()
    {
        if(m_itemPlacement1.ObjectStored != null && m_itemPlacement2 != null && hasActivatedOnce == false)
        {
            hasActivatedOnce = true;
            m_monsterButterflyGO.SetActive(true);
            audioManager.Play("FullMusic", GetComponent<AudioSource>());
            Destroy(this);
        }
    }
}
