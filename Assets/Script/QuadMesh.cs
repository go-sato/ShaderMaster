using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class QuadMesh : MonoBehaviour {

	[SerializeField]
	private Material _mat;

	private void Start () {
		Mesh mesh = new Mesh ();
		mesh.vertices = new Vector3[] {
			new Vector3 (-2.0f, 0.0f, 2.0f),
			new Vector3 (-2.0f, 0.0f, -2.0f),
			new Vector3 (2.0f, 0.0f, -2.0f),
			new Vector3 (2.0f, 0.0f, 2.0f),
		};

		//三角形のインデックスは3頂点ごとに指定
		mesh.triangles = new int[] {
			2, 1, 0, 0, 3, 2
		};

		mesh.uv = new Vector2[] {
			new Vector2 (0.0f, 1.0f),
			new Vector2 (0.0f, 0.0f),
			new Vector2 (1.0f, 0.0f),
			new Vector2 (1.0f, 1.0f),
		};

		mesh.colors = new Color[] {
			Color.red,
			Color.blue,
			Color.green,
			Color.yellow,
		};

		var filter = GetComponent<MeshFilter> ();
		filter.sharedMesh = mesh;
		filter.sharedMesh.name = "OriginalQuad";
	}
	
	public void OnWillRenderObject()
	{
		if (_mat == null) {
			return;
		}

		Camera renderCamera = Camera.current;

		Matrix4x4 m = GetComponent<Renderer> ().localToWorldMatrix;
		Matrix4x4 v = renderCamera.worldToCameraMatrix;
		Matrix4x4 p = renderCamera.cameraType == CameraType.SceneView ? 
			GL.GetGPUProjectionMatrix (renderCamera.projectionMatrix, true) : renderCamera.projectionMatrix;

		Matrix4x4 mvp = p * v * m;
		Matrix4x4 mv = v * m;

		_mat.SetMatrix ("mvp_matrix", mvp);
		_mat.SetMatrix ("mv_matrix", mv);
		_mat.SetMatrix ("v_matrix", v);

		var renderer = GetComponent<MeshRenderer> ();
		renderer.material = _mat;
	}
}
