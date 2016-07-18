using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class MVP : MonoBehaviour {

	[SerializeField]
	private Material material;

	public void OnWillRenderObject()
	{
		if (material == null) {
			return;
		}

		Camera renderCamera = Camera.current;

		Matrix4x4 m = GetComponent<Renderer> ().localToWorldMatrix;
		Matrix4x4 v = renderCamera.worldToCameraMatrix;
		Matrix4x4 p = renderCamera.cameraType == CameraType.SceneView ? 
			GL.GetGPUProjectionMatrix (renderCamera.projectionMatrix, true) : renderCamera.projectionMatrix;

		Matrix4x4 mvp = p * v * m;
		Matrix4x4 mv = v * m;
	}
}
