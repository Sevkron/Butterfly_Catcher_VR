using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class Timer : MonoBehaviour
{
    Image fillImg;
    public float timer = 10;
    float time;
    public Text timeText;

    // Use this for initialization
    void Start()
    {
        fillImg = this.GetComponent<Image>();
        time = timer;
    }

    // Update is called once per frame
    void Update()
    {
        if (time > 0)
        {
            time -= Time.deltaTime;
            fillImg.fillAmount = time / timer;
            timeText.text = "Time : " + time.ToString("F");
        }
    }
}