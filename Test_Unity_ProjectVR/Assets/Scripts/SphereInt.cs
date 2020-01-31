using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class SphereInt : MonoBehaviour
{
    Coroutine delay;
    Tween myTween;
    private bool activeOnce = true;
    
    public void StartTimer(float timer)
    {
        if(activeOnce == true)
        {
            Debug.Log("Started Timer");
            transform.GetChild(0).gameObject.SetActive(true);
            GetComponent<SphereCollider>().enabled = true;
            activeOnce = false;
            delay = StartCoroutine(Delay(timer));
        }

    }

    public IEnumerator Delay(float timer)
    {
        myTween = transform.GetChild(0).transform.DOScale(new Vector3(0,0,0), timer);
        yield return myTween.WaitForCompletion();
        transform.parent.GetComponent<SphMinigame>().MinigameFail();
    }

    public void Caught()
    {
        myTween.Kill(false);
        StopCoroutine(delay);
        transform.parent.GetComponent<SphMinigame>().CaughtSuccess();
        Destroy(this.gameObject);
    }
}
