using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.UI;

public class SphereInt : MonoBehaviour
{
    Coroutine delay;
    Coroutine VFXDelay;
    Tween myTween;
    private bool activeOnce = true;

    [HideInInspector] 
    private SphMinigame m_sphMinigame;
    public ParticleSystem CapFailVFX;
    public ParticleSystem CapSuccessVFX;
    public ParticleSystem CapSpawnVFX;
    private bool isLastSphere;

    public Text timeText;
    public Image fillImg;
    float timeElapsed;
    float tweenDuration;
    void Start()
    {
        m_sphMinigame = transform.parent.GetComponent<SphMinigame>();
    }

    void Update()
    {
        if(myTween != null)
        {
            if(timeElapsed < tweenDuration)
            {
                float totalTime = myTween.Duration();
                float currentTime = Mathf.Lerp(tweenDuration, 0, timeElapsed / totalTime);
                timeText.text = Math.Round(currentTime, 1).ToString() + " s";
                timeElapsed += Time.deltaTime;
            }
        }
    }
    public void StartTimer(float timer, bool isFinal)
    {
        isLastSphere = isFinal;
        if(activeOnce == true)
        {
            GetComponent<SphereCollider>().enabled = true;
            activeOnce = false;
            delay = StartCoroutine(Delay(timer));
        }

    }

    public IEnumerator Delay(float timer)
    {
        myTween = fillImg.DOFillAmount(0, timer);
        tweenDuration = myTween.Duration();
        yield return myTween.WaitForCompletion();
        VFXDelay = StartCoroutine(VFXTime(CapFailVFX));
        
    }

    public void Caught()
    {
        myTween.Kill(false);
        StopCoroutine(delay);
        GetComponent<SphereCollider>().enabled = false;

        //VFX = StartCoroutine(CapSuccessVFX.Play();
        //CapSuccessVFX.Play(); //WHAT

        if(isLastSphere == false)
        {
            VFXDelay = StartCoroutine(VFXTime(CapSuccessVFX));
            //m_sphMinigame.CaughtSuccess();
        }else
        {
            VFXDelay = StartCoroutine(VFXTime(CapSuccessVFX));
        }
    }

    public IEnumerator VFXTime(ParticleSystem particleSystem)
    {
        float f = particleSystem.main.duration;
        //float f = 5f;
        particleSystem.Play();
        Debug.Log("Started VFXTimer");
        yield return new WaitForSeconds(f);
        
        if(particleSystem == CapFailVFX)
        {
            m_sphMinigame.MinigameFail();
        }else
        {
            m_sphMinigame.CaughtSuccess();
        }
    }
}
