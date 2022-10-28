import CoreLocation

protocol LocationService {
    var authorizationStatus: CLAuthorizationStatus { get }
    func requestWhenInUseAuthorization() async -> CLAuthorizationStatus
}

class CoreLocationService: NSObject, LocationService, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    var authorizationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    func requestWhenInUseAuthorization() async -> CLAuthorizationStatus {
        var delegate: LocationPermissionDelegate!
        return await withCheckedContinuation { continuation in
            delegate = LocationPermissionDelegate(continuation: continuation)
            locationManager.delegate = delegate
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

class LocationPermissionDelegate: NSObject,  CLLocationManagerDelegate {
    let continuation: CheckedContinuation<CLAuthorizationStatus, Never>
    
    init(continuation: CheckedContinuation<CLAuthorizationStatus, Never>) {
        self.continuation = continuation
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        continuation.resume(returning: manager.authorizationStatus)
    }
}
