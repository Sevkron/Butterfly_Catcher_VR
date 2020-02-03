using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

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

    void Start()
    {
        m_sphMinigame = transform.parent.GetComponent<SphMinigame>();
    }
    public void StartTimer(float timer)
    {
        if(activeOnce == true)
        {
            //Debug.Log("Started Timer");
            transform.GetChild(0).gameObject.SetActive(true);
            GetComponent<SphereCollider>().enabled = true;
            activeOnce = false;
            delay = StartCoroutine(Delay(timer));
            VFXDelay = StartCoroutine(VFXTime(CapSpawnVFX));
        }

    }

    public IEnumerator Delay(float timer)
    {
        myTween = transform.GetChild(0).transform.DOScale(new Vector3(0,0,0), timer);
        yield return myTween.WaitForCompletion();
        VFXDelay = StartCoroutine(VFXTime(CapFailVFX));
        
    }

    public void Caught()
    {
        myTween.Kill(false);
        StopCoroutine(delay);
        GetComponent<SphereCollider>().enabled = false;
        VFXDelay = StartCoroutine(VFXTime(CapSuccessVFX));
    }

    public IEnumerator VFXTime(ParticleSystem particleSystem)
    {
        float f = particleSystem.main.duration;
        //float f = 5f;
        particleSystem.Play();
        Debug.Log("Started VFXTimer");
        yield return new WaitForSeconds(f);

        if(particleSystem == CapSuccessVFX)
        {
            m_sphMinigame.CaughtSuccess();
            Destroy(this.gameObject);
        }
        else if(particleSystem == CapFailVFX)
        {
            m_sphMinigame.MinigameFail();
        }
    }
}
