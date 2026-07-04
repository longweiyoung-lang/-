import Foundation
import SwiftData

@Model
final class SightingEntity {
    @Attribute(.unique) var id: String
    var speciesId: String
    var commonNameZh: String
    var scientificName: String
    var categoryRawValue: String
    var photoURLString: String?
    var localImageName: String
    var foundAt: Date
    var blurredLatitude: Double?
    var blurredLongitude: Double?
    var locationName: String?
    var confidence: Double
    var createdAt: Date

    init(
        id: String = UUID().uuidString,
        speciesId: String,
        commonNameZh: String,
        scientificName: String,
        category: SpeciesCategory,
        photoURL: URL? = nil,
        localImageName: String,
        foundAt: Date = .now,
        blurredLatitude: Double? = nil,
        blurredLongitude: Double? = nil,
        locationName: String? = nil,
        confidence: Double,
        createdAt: Date = .now
    ) {
        self.id = id
        self.speciesId = speciesId
        self.commonNameZh = commonNameZh
        self.scientificName = scientificName
        self.categoryRawValue = category.rawValue
        self.photoURLString = photoURL?.absoluteString
        self.localImageName = localImageName
        self.foundAt = foundAt
        self.blurredLatitude = blurredLatitude
        self.blurredLongitude = blurredLongitude
        self.locationName = locationName
        self.confidence = confidence
        self.createdAt = createdAt
    }

    var category: SpeciesCategory {
        SpeciesCategory(rawValue: categoryRawValue) ?? .unknown
    }
}

