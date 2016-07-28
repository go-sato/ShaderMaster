using UnityEngine;
using System.Collections;

public class DissolveController : MonoBehaviour {

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		GetComponent<Renderer> ().material.SetFloat ("_Threshhold", Mathf.Abs(Mathf.Sin (Time.time / 3)) * 0.5f + 0.2f);
	}
}
