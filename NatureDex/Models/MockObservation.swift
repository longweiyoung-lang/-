import CoreLocation
import Foundation

struct MockObservation: Identifiable {
    let id = UUID()
    let commonNameZh: String
    let scientificName: String
    let category: SpeciesCategory
    let discoveredAt: Date
    let imageSystemName: String
    let blurredCoordinate: CLLocationCoordinate2D?
    let locationName: String
    let confidence: Double
}

extension MockObservation {
    static let samples: [MockObservation] = NatureDexMockData.sightings.map { sighting in
        MockObservation(
            commonNameZh: sighting.commonNameZh,
            scientificName: sighting.scientificName,
            category: sighting.category,
            discoveredAt: sighting.foundAt,
            imageSystemName: sighting.category.symbolName,
            blurredCoordinate: sighting.blurredCoordinate,
            locationName: sighting.locationName ?? "未知区域",
            confidence: sighting.confidence
        )
    }
}

private extension Sighting {
    var blurredCoordinate: CLLocationCoordinate2D? {
        guard let blurredLatitude, let blurredLongitude else {
            return nil
        }

        return CLLocationCoordinate2D(latitude: blurredLatitude, longitude: blurredLongitude)
    }
}
