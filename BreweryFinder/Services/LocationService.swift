import CoreLocation

protocol LocationService {
    var authorizationStatus: CLAuthorizationStatus { get }
    func requestWhenInUseAuthorization() async -> CLAuthorizationStatus
    func getLocation() async throws -> CLLocationCoordinate2D
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
    
    func getLocation() async throws -> CLLocationCoordinate2D {
        var delegate: LocationRequestDelegate!
        return try await withCheckedThrowingContinuation { continuation in
            delegate = LocationRequestDelegate(continuation: continuation)
            locationManager.delegate = delegate
            locationManager.requestLocation()
        }
    }
}

class LocationPermissionDelegate: NSObject, CLLocationManagerDelegate {
    let continuation: CheckedContinuation<CLAuthorizationStatus, Never>
    
    init(continuation: CheckedContinuation<CLAuthorizationStatus, Never>) {
        self.continuation = continuation
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        continuation.resume(returning: manager.authorizationStatus)
    }
}

class LocationRequestDelegate: NSObject, CLLocationManagerDelegate {
    struct NoLocationError: Error {}
    
    let continuation: CheckedContinuation<CLLocationCoordinate2D, Error>
    
    init(continuation: CheckedContinuation<CLLocationCoordinate2D, Error>) {
        self.continuation = continuation
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            continuation.resume(returning: location.coordinate)
        } else {
            continuation.resume(throwing: NoLocationError())
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation.resume(throwing: error)
    }
}
