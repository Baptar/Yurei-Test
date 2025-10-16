using UnityEngine;

public class CameraZone : MonoBehaviour
{
    // The camera linked to this area
    public Camera zoneCamera; 
    [SerializeField] private bool deactivateCameraOnStart = false;
    
    private void Start()
    {
        // if we want to deactivate camera associated at start 
        if (zoneCamera != null)
            zoneCamera.enabled = !deactivateCameraOnStart;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            CameraManager.Instance.SwitchTo(zoneCamera);
        }
    }
}