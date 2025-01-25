using System.Collections;
using System.Collections.Generic;
using UFE3D;
using UnityEngine;

public class ProjectileTrajectoryFix : MonoBehaviour
{
    enum DirType
    {
        Target,
        Camera
    }

    [SerializeField] DirType dirType = DirType.Target;

    private Camera _camera;
    private Camera Camera
    {
        get
        {
            if (_camera == null) _camera = Camera.main;
            return _camera;
        }
    }
    
    IEnumerator Start()
    {
        yield return new WaitForFixedUpdate();
        Vector3 target = GetTargetPosition();
        transform.forward = (target - transform.position).normalized;
    }

    Vector3 GetTargetPosition()
    {
        switch (dirType)
        {
            case DirType.Target:
                ProjectileMoveScript projectileScript = GetComponent<ProjectileMoveScript>();
                return projectileScript.target.ToVector();

            case DirType.Camera:
                return Camera.transform.position;
                break;
        }
        
        return Vector3.zero;
    }
}