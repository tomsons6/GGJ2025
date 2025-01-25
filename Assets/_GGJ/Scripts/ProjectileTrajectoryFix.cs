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

    private Vector3? _target;

    IEnumerator Start()
    {
        yield return new WaitForFixedUpdate();

        int cnt = 0;

        do
        {
            TryGetTargetPosition();

            if (_target.HasValue)
            {
                transform.forward = (_target.GetValueOrDefault() - transform.position).normalized;
                yield break;
            }

            yield return null;
        } while (cnt++ < 30);
    }

    void TryGetTargetPosition()
    {
        switch (dirType)
        {
            case DirType.Target:
                ProjectileMoveScript projectileScript = GetComponent<ProjectileMoveScript>();
                if (projectileScript)
                {
                    _target = projectileScript.target.ToVector();
                }

                break;
            case DirType.Camera:
                if (Camera.main)
                {
                    _target = Camera.main.transform.position;
                }

                break;
        }
    }
}