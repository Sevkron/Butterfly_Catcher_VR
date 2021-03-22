using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using BehaviorDesigner.Runtime;

public class DayNightCycle : MonoBehaviour
{

    [Header("Time")]
    [Tooltip("Day Length in Minutes")]
    [SerializeField]
    private float _targetDayLength = 0.5f; //length of day in minutes
    public float targetDayLength
    {
        get
        {
            return _targetDayLength;
        }
    }
    [SerializeField]
    private float elapsedTime;
    [SerializeField]
    private bool use24Clock = true;
    [SerializeField]
    private TextMeshProUGUI[] clockTextMeshPro;
    [SerializeField]
    private Image[] clockFill;

    [SerializeField]
    private float _hourPeriod;
    public float hourPeriod
    {
        get
        {
            return _hourPeriod;
        }
    }
    [SerializeField]
    [Range(0f, 1f)]
    private float _timeOfDay;
    public float timeOfDay
    {
        get
        {
            return _timeOfDay;
        }
    }
    [SerializeField]
    private int _dayNumber = 0; //tracks the days passed
    public int dayNumber
    {
        get
        {
            return _dayNumber;
        }
    }
    [SerializeField]
    private int _yearNumber = 0;
    public int yearNumber
    {
        get
        {
            return _yearNumber;
        }
    }
    private float _timeScale = 100f;
    [SerializeField]
    private int _yearLength = 100;
    public float yearLength
    {
        get
        {
            return _yearLength;
        }
    }
    public bool pause = false;
    [SerializeField]
    private AnimationCurve timeCurve;
    private float timeCurveNormalization;


    [Header("Sun Light")]
    [SerializeField]
    private Transform dailyRotation;
    [SerializeField]
    private Light sun;
    private float intensity;
    [SerializeField]
    private float sunBaseIntensity = 1f;
    [SerializeField]
    private float sunVariation = 1.5f;
    [SerializeField]
    private Gradient sunColor;

    [Header("Seasonal Variable")]
    [SerializeField]
    private Transform sunSeasonalRotation;
    [SerializeField]
    [Range(-45f, 45f)]
    private float maxseasonalTilt;


    [Header("Modules")]
    private List<DNModuleBase> moduleList = new List<DNModuleBase>();

    private void Start()
    {
        NormalTimeCurve();
    }


    private void Update()
    {
        if(!pause)
        {
            UpdateTimeScale();
            UpdateTime();
            UpdateClock();
        }

        AdjustSunRotation();
        SunIntensity();
        AdjustSunColor();
        UpdateModules(); //will update modules each frame (peut etre fait avec une coroutine pour ameliorer les perf)
    }

    private void UpdateTimeScale()
    {
        _timeScale = 24 / (_targetDayLength / 60);
        _timeScale *= timeCurve.Evaluate(elapsedTime / (targetDayLength * 60)); //change timescale based on time curve
        _timeScale /= timeCurveNormalization; //keeps day length at target value
    }

    private void NormalTimeCurve()
    {
        float stepSize = 0.01f;
        int numberSteps = Mathf.FloorToInt(1f / stepSize);
        float curveTotal = 0;

        for (int i = 0; i < numberSteps; i++)
        {
            curveTotal += timeCurve.Evaluate(i * stepSize);
        }

        timeCurveNormalization = curveTotal / numberSteps;
    
    }

    private void UpdateTime()
    {
        _timeOfDay += Time.deltaTime * _timeScale / 86400;
        elapsedTime += Time.deltaTime;

        if(_timeOfDay > 1) //new day!
        {
            elapsedTime = 0;
            _dayNumber++;
            _timeOfDay -= 1;

            if (_dayNumber > _yearLength) //new year!!
            {
                _yearNumber++;
                _dayNumber = 0;
            }
        }
        
    }

    private void UpdateClock()
    {
        string minuteText;
        string hourText;
        float time = elapsedTime / (targetDayLength * 60);
        float hour = Mathf.FloorToInt( time * 24);
        float minute = Mathf.FloorToInt (((time * 24) - hour)*60);
        _hourPeriod = hour;

        if(minute < 10)
        {
            minuteText = "0" + minute.ToString();
        }
        else
        {
            minuteText = "" + minute.ToString();
        }

        if (hour < 10)
        {
            hourText = "0" + hour.ToString();
        }
        else
        {
            hourText = "" + hour.ToString();
        }

        for(int i = 0; i < clockTextMeshPro.Length; i++)
        {
            clockTextMeshPro[i].text = hourText + " : " + minuteText;
        }

        for(int i = 0; i < clockFill.Length; i++)
        {
            clockFill[i].fillAmount = timeOfDay;
        }
    }

    //rotates the sun daily 
    private void AdjustSunRotation()
    {
        float sunAngle = timeOfDay * 360f;
        dailyRotation.transform.localRotation = Quaternion.Euler(new Vector3(0f, 0f, sunAngle));

        float seasonalAngle = -maxseasonalTilt * Mathf.Cos(_dayNumber / yearLength * 2f * Mathf.PI);
        sunSeasonalRotation.localRotation = Quaternion.Euler(new Vector3(seasonalAngle, 0f, 0f));

    }

    private void SunIntensity()
    {
        intensity = Vector3.Dot(sun.transform.forward, Vector3.down);
        intensity = Mathf.Clamp01(intensity);

        sun.intensity = intensity * sunVariation + sunBaseIntensity;
    }

        
   private void AdjustSunColor()
    {
        sun.color = sunColor.Evaluate(intensity);
    }

    public void AddModule(DNModuleBase module)
    {
        moduleList.Add(module);
    }
    public void RemoveModule(DNModuleBase module)
    {
        moduleList.Remove(module);
    }

    //update each module based on current sun intensity
    private void UpdateModules()
    {
        foreach (DNModuleBase module in moduleList)
        {
            module.UpdateModule(intensity);
        }
    }
}