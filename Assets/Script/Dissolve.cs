using UnityEngine;
using System.Collections;
using UnityEngine;

public class Dissolve : MonoBehaviour {

	[SerializeField]
	private float time = 1f; // 再生時間
	[SerializeField]
	private float waitTime = 1f; // 再生までの待ち時間

	private Material material = null;
	private int _Width = 0;
	private int _Cutoff = 0;

	private float duration = 0f; // 残時間
	private float halfTime = 0f; // 再生時間の半分

	void Start () {
		material = GetComponentInChildren<Renderer>().material;
		_Width = Shader.PropertyToID("_Width");
		_Cutoff = Shader.PropertyToID("_CutOff");

		if(material != null)
		{
			material.SetFloat(_Cutoff, 1f);
			material.SetFloat(_Width, 1f);
		}
		halfTime = time / 4f * 3f; // 半分といいつつ4/3にしているのは、見た目の調整のため
		duration = time;
	}

	void Update () {

		float width;

		width = Mathf.Abs(Mathf.Sin (Time.time)) - 0.5f;

		// シェーダーに値を渡す
		if (material != null)
		{
//			material.SetFloat(_Cutoff, cutoff);
			material.SetFloat(_Width, width);
		}

	}
}