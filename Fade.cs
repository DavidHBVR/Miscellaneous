using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Fade : MonoBehaviour
{
    public GameObject fadeSphere;
    public bool fadeAtStart;

    public void Start()
    {
        if (fadeAtStart)
        {
            StartCoroutine(FadeIn());
        }
    }
    public IEnumerator FadeIn()
    {
        float t = 0f;
        while (t < 1f)
        {
            t += Time.deltaTime;
            float alpha = Mathf.Lerp(1f, 0f, t);
            fadeSphere.GetComponent<Renderer>().material.color = new Color(0f, 0f, 0f, alpha);
            yield return null;
        }
    }

    public IEnumerator FadeOut()
    {
        float t = 0f;
        while (t < 1f)
        {
            t += Time.deltaTime;
            float alpha = Mathf.Lerp(0f, 1f, t);
            fadeSphere.GetComponent<Renderer>().material.color = new Color(0f, 0f, 0f, alpha);
            yield return null;
        }
    }

    public void StartFadeOut()
    {
        StartCoroutine(FadeOut());
    }
}
