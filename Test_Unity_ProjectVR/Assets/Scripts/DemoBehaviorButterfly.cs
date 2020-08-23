using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DemoBehaviorButterfly : MonoBehaviour
{
    private BoxCollider triggerZone;
    public bool move;
    // Start is called before the first frame update
    void Start()
    {
        triggerZone = GetComponent<BoxCollider>();
    }

    // Update is called once per frame
    void Update()
    {
        if(move == true){
            transform.Translate(Vector3.forward * 3 * Time.deltaTime);
            StartCoroutine(Delay());
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            triggerZone.enabled = false;
            move = true;
        }
    }

    public IEnumerator Delay()
    {
        yield return new WaitForSeconds(20);
        Destroy(this.gameObject);
    }
}
