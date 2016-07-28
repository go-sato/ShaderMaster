using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class BoxMesh : MonoBehaviour {

	[SerializeField]
	private Material _mat;

	private void Start () {
		Mesh mesh = new Mesh ();
		mesh.vertices = new Vector3[] {
			new Vector3 (0.0f, 0.0f, 0.0f),
			new Vector3 (1.0f, 0.0f, 0.0f),
			new Vector3 (1.0f, 1.0f, 0.0f),
			new Vector3 (0.0f, 1.0f, 0.0f),

			new Vector3 (1.0f, 0.0f, 0.0f),
			new Vector3 (1.0f, 0.0f, 1.0f),
			new Vector3 (1.0f, 1.0f, 1.0f),
			new Vector3 (1.0f, 1.0f, 0.0f),

			new Vector3 (1.0f, 0.0f, 1.0f),
			new Vector3 (0.0f, 0.0f, 1.0f),
			new Vector3 (0.0f, 1.0f, 1.0f),
			new Vector3 (1.0f, 1.0f, 1.0f),

			new Vector3 (0.0f, 0.0f, 1.0f),
			new Vector3 (0.0f, 0.0f, 0.0f),
			new Vector3 (0.0f, 1.0f, 0.0f),
			new Vector3 (0.0f, 1.0f, 1.0f),

			new Vector3 (0.0f, 1.0f, 0.0f),
			new Vector3 (1.0f, 1.0f, 0.0f),
			new Vector3 (1.0f, 1.0f, 1.0f),
			new Vector3 (0.0f, 1.0f, 1.0f),

			new Vector3 (0.0f, 0.0f, 0.0f),
			new Vector3 (0.0f, 0.0f, 1.0f),
			new Vector3 (1.0f, 0.0f, 1.0f),
			new Vector3 (1.0f, 0.0f, 0.0f),
		};


		//時計回りに頂点を結んだ面が前面(法線の向き)左手座標系
		mesh.triangles = new int[] {
			0, 3, 2,
			2, 1, 0,
			4, 7, 6,
			6, 5, 4,
			8, 11, 10,
			10, 9, 8,
			12, 15, 14,
			14, 13, 12,
			16, 19, 18,
			18, 17 ,16,
			20, 23, 22,
			22, 21, 20,
		};

		//各頂点に対してuv座標を設定
		mesh.uv = new Vector2[] {
			new Vector2 (0.0f, 0.0f),
			new Vector2 (1.0f, 0.0f),
			new Vector2 (1.0f, 0.05f),
			new Vector2 (0.0f, 0.05f),

			new Vector2 (0.0f, 0.0f),
			new Vector2 (1.0f, 0.0f),
			new Vector2 (1.0f, 0.05f),
			new Vector2 (0.0f, 0.05f),

			new Vector2 (0.0f, 0.0f),
			new Vector2 (1.0f, 0.0f),
			new Vector2 (1.0f, 0.05f),
			new Vector2 (0.0f, 0.05f),

			new Vector2 (0.0f, 0.0f),
			new Vector2 (1.0f, 0.0f),
			new Vector2 (1.0f, 0.05f),
			new Vector2 (0.0f, 0.05f),

			new Vector2 (0.0f, 0.0f),
			new Vector2 (1.0f, 0.0f),
			new Vector2 (1.0f, 1.0f),
			new Vector2 (0.0f, 1.0f),

			new Vector2 (0.0f, 0.0f),
			new Vector2 (1.0f, 0.0f),
			new Vector2 (1.0f, 1.0f),
			new Vector2 (0.0f, 1.0f),
		};

//		mesh.colors = new Color[] {
//			Color.blue,
//			Color.red,
//			Color.green,
//			Color.yellow,
//		};

		var filter = GetComponent<MeshFilter> ();
		filter.sharedMesh = mesh;
		filter.sharedMesh.name = "OriginalVoxel";

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
