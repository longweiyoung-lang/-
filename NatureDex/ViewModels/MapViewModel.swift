import CoreLocation
import Foundation
import MapKit
import SwiftUI

@MainActor
final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var position: MapCameraPosition
    @Published var authorizationStatus: CLAuthorizationStatus

    private let locationManager = CLLocationManager()

    override init() {
        position = .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 31.2304, longitude: 121.4737),
                span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
            )
        )
        authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
    }

    var hasLocationPermission: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }

    var canRequestPermission: Bool {
        authorizationStatus == .notDetermined
    }

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor [weak self] in
            self?.authorizationStatus = status
        }
    }

    func coordinate(for sighting: SightingEntity) -> CLLocationCoordinate2D? {
        guard let latitude = sighting.blurredLatitude, let longitude = sighting.blurredLongitude else {
            return nil
        }

        return blurCoordinate(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }

    func updateCameraIfNeeded(for sightings: [SightingEntity]) {
        guard let firstCoordinate = sightings.compactMap({ coordinate(for: $0) }).first else {
            return
        }

        position = .region(
            MKCoordinateRegion(
                center: firstCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
            )
        )
    }

    private func blurCoordinate(_ coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let precisionMeters = 500.0
        let latitudeDegrees = precisionMeters / 111_000.0
        let longitudeDegrees = precisionMeters / (111_000.0 * max(cos(coordinate.latitude * .pi / 180), 0.01))

        return CLLocationCoordinate2D(
            latitude: (coordinate.latitude / latitudeDegrees).rounded() * latitudeDegrees,
            longitude: (coordinate.longitude / longitudeDegrees).rounded() * longitudeDegrees
        )
    }
}
