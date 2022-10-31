import CoreLocation

/// `LocationService` abstracts access to location data for the device.
protocol LocationService {
    /// Get the app's current level of access to location data.
    ///
    /// - Returns: Current authorization status
    var authorizationStatus: CLAuthorizationStatus { get }
    
    /// Request authorization to use location data for the app. This prompts the user for location access and
    /// then, when completed, return the new authorization status.
    ///
    /// - Returns: Authorization status after prompting the user
    func requestWhenInUseAuthorization() async -> CLAuthorizationStatus
    
    /// Get a single location coordinate from the system.
    ///
    /// - Throws: `NoLocationError` if no location was available, or any underlying error thrown by the system.
    /// - Returns: Coordinate
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
    var continuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    
    init(continuation: CheckedContinuation<CLAuthorizationStatus, Never>) {
        self.continuation = continuation
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        continuation?.resume(returning: manager.authorizationStatus)
        continuation = nil
    }
}

class LocationRequestDelegate: NSObject, CLLocationManagerDelegate {
    struct NoLocationError: Error {}
    
    var continuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    
    init(continuation: CheckedContinuation<CLLocationCoordinate2D, Error>) {
        self.continuation = continuation
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            continuation?.resume(returning: location.coordinate)
            continuation = nil
        } else {
            continuation?.resume(throwing: NoLocationError())
            continuation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}
