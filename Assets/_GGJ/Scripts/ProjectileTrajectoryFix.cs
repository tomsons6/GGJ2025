using System.Collections;
using System.Collections.Generic;
using UFE3D;
using UnityEngine;

public class ProjectileTrajectoryFix : MonoBehaviour
{
    IEnumerator Start()
    {   
        yield return new WaitForFixedUpdate();
        ProjectileMoveScript projectileScript = GetComponent<ProjectileMoveScript>();

        Vector3 target = projectileScript.target.ToVector();
        transform.forward = (target - transform.position).normalized;
    }
}
