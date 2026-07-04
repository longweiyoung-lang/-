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
    static let samples: [MockObservation] = [
        MockObservation(
            commonNameZh: "月季",
            scientificName: "Rosa chinensis",
            category: .plant,
            discoveredAt: .now.addingTimeInterval(-3600),
            imageSystemName: "camera.macro",
            blurredCoordinate: CLLocationCoordinate2D(latitude: 31.2304, longitude: 121.4737),
            locationName: "上海市附近",
            confidence: 0.86
        ),
        MockObservation(
            commonNameZh: "七星瓢虫",
            scientificName: "Coccinella septempunctata",
            category: .insect,
            discoveredAt: .now.addingTimeInterval(-86_400),
            imageSystemName: "ladybug",
            blurredCoordinate: CLLocationCoordinate2D(latitude: 31.2240, longitude: 121.4810),
            locationName: "公园附近",
            confidence: 0.79
        ),
        MockObservation(
            commonNameZh: "白头鹎",
            scientificName: "Pycnonotus sinensis",
            category: .bird,
            discoveredAt: .now.addingTimeInterval(-172_800),
            imageSystemName: "bird",
            blurredCoordinate: CLLocationCoordinate2D(latitude: 31.2380, longitude: 121.4620),
            locationName: "小区附近",
            confidence: 0.74
        )
    ]
}

