import Foundation
import MapKit
import SwiftUI

@MainActor
final class MapViewModel: ObservableObject {
    @Published var observations: [MockObservation]
    @Published var position: MapCameraPosition

    init(observations: [MockObservation] = MockObservation.samples) {
        self.observations = observations
        self.position = .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 31.2304, longitude: 121.4737),
                span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
            )
        )
    }

    var mappableObservations: [MockObservation] {
        observations.filter { $0.blurredCoordinate != nil }
    }
}
