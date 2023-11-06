using UnityEngine;

public class FollowTarget : MonoBehaviour
{
    public Transform target; 

    public bool followX = false; 
    public bool followY = true; 
    public bool followZ = false; 
    public float positionSmoothSpeed = 0.125f; 

    // Pour la rotation
    public bool followRotation = false; 
    public float rotationSmoothSpeed = 0.125f; 

    void FixedUpdate()
    {
        if (target)
        {
            // Suivi de position
            Vector3 targetPosition = target.position;
            if (!followX) targetPosition.x = transform.position.x;
            if (!followY) targetPosition.y = transform.position.y;
            if (!followZ) targetPosition.z = transform.position.z;
            transform.position = Vector3.Lerp(transform.position, targetPosition, positionSmoothSpeed);

            // Suivi de rotation
            if (followRotation)
            {
                Quaternion targetRotation = target.rotation;
                transform.rotation = Quaternion.Lerp(transform.rotation, targetRotation, rotationSmoothSpeed);
            }
        }
    }
}
