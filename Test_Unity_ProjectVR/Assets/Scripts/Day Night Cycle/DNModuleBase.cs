using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class DNModuleBase : MonoBehaviour

{
    protected DayNightCycle dayNightControle;

    private void OnEnable()
    {
        dayNightControle = this.GetComponent<DayNightCycle>();

        if(dayNightControle != null)
            dayNightControle.AddModule(this);
    }

    private void OnDisable()
    {
        if (dayNightControle != null)
            dayNightControle.RemoveModule(this);
    }

    public abstract void UpdateModule(float intensity);

}
