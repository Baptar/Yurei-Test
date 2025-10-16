using UnityEngine;

public class CameraZone : MonoBehaviour
{
    // The camera linked to this area
    public Camera zoneCamera; 
    [SerializeField] private bool deactivateCameraOnStart = false;
    [SerializeField] private GameObject[] objectToActivate;
    
    private void Start()
    {
        // if we want to deactivate camera associated at start 
        if (zoneCamera != null)
            zoneCamera.enabled = !deactivateCameraOnStart;
        
        foreach (GameObject obj in objectToActivate)
            obj.SetActive(false);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            CameraManager.Instance.SwitchTo(zoneCamera);
            LightZoneManager.Instance.OnEnterNewZone(this);
            ManagerObjectToActivate(true);
        }
    }

    public void ManagerObjectToActivate(bool activate)
    {
        foreach (GameObject obj in objectToActivate)
            obj.SetActive(activate);
    }
}