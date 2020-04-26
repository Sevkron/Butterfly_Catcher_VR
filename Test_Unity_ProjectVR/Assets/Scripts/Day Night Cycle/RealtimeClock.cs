using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class RealtimeClock : MonoBehaviour
{
    [SerializeField]
    private bool use24Clock = true;
    [SerializeField]
    private TextMeshProUGUI[] clockTextMeshPro;
    [SerializeField]
    private Image[] clockFill;
    [SerializeField]
    private float elapsedTime;
    [SerializeField]
    private float _hourPeriod;
    [Range(0f, 1f)]
    private float _timeOfDay;
    public float timeOfDay
    {
        get
        {
            return _timeOfDay;
        }
    }
    public float hourPeriod
    {
        get
        {
            return _hourPeriod;
        }
    }
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //_timeOfDay += System.DateTime.Now;
        UpdateClock();
    }

    private void UpdateClock()
    {
        var time = System.DateTime.Now;
        string minuteText;
        if (time.Minute < 10)
        {
            minuteText = "0" + time.Minute.ToString();
        }else{
            minuteText = time.Minute.ToString();
        }
        
        string hourText = time.Hour.ToString();

        for(int i = 0; i < clockTextMeshPro.Length; i++)
        {
            clockTextMeshPro[i].text = hourText + " : " + minuteText;
        }

        for(int i = 0; i < clockFill.Length; i++)
        {
            clockFill[i].fillAmount = timeOfDay;
        }
    }
}
