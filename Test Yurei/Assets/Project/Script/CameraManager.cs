using UnityEngine;

public class CameraManager : MonoBehaviour
{
    public static CameraManager Instance;
    public Camera CurrentCamera { get; private set; }
    public Camera PreviousCamera { get; private set; }

    private void Awake()
    {
        if (Instance == null)
            Instance = this;
        else
            Destroy(gameObject);
    }

    public void SwitchTo(Camera newCam)
    {
        if (newCam == CurrentCamera) return;

        PreviousCamera = CurrentCamera;
        CurrentCamera = newCam;
    }
}
