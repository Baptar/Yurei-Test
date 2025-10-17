using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;

public class CameraZone : MonoBehaviour
{
    // The camera linked to this area
    public Camera zoneCamera; 
    [SerializeField] private bool deactivateCameraOnStart = false;
    [SerializeField] private GameObject[] objectToActivate;
    
    [SerializeField] private RawImage _renderTexture;
    [SerializeField] private Color _colorDeactivated;
    
    private void Start()
    {
        // if we want to deactivate camera associated at start 
        if (zoneCamera != null)
            zoneCamera.enabled = !deactivateCameraOnStart;
        
        foreach (GameObject obj in objectToActivate)
            obj.SetActive(false);
        
        ManageRenderTexturesLight(false);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            CameraManager.Instance.SwitchTo(zoneCamera);
            LightZoneManager.Instance.OnEnterNewZone(this);
            ManagerObjectToActivate(true);
            ManageRenderTexturesLight(true);
        }
    }

    public void ManagerObjectToActivate(bool activate)
    {
        foreach (GameObject obj in objectToActivate)
            obj.SetActive(activate);
    }
    
    public void ManageRenderTexturesLight(bool activate)
    {
        //_renderTexture.color = activate? Color.white : _colorDeactivated;
        _renderTexture.DOColor(activate? Color.white : _colorDeactivated, 0.2f);
    }
}