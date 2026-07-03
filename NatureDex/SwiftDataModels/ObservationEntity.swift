import Foundation
import SwiftData

@Model
final class ObservationEntity {
    @Attribute(.unique) var id: String
    var speciesId: String
    var commonNameZh: String
    var scientificName: String
    var categoryRawValue: String
    var photoLocalPath: String
    var thumbnailLocalPath: String?
    var sourceRawValue: String
    var observedAt: Date
    var createdAt: Date
    var locationEnabled: Bool
    var locationDisplayName: String?
    var blurredLatitude: Double?
    var blurredLongitude: Double?
    var precisionMeters: Double?
    var recognitionRequestId: String?
    var confirmedCandidateId: String?
    var confidence: Double?

    init(
        id: String = UUID().uuidString,
        speciesId: String,
        commonNameZh: String,
        scientificName: String,
        category: SpeciesCategory,
        photoLocalPath: String,
        thumbnailLocalPath: String? = nil,
        source: ObservationSource,
        observedAt: Date = .now,
        createdAt: Date = .now,
        locationEnabled: Bool = false,
        locationDisplayName: String? = nil,
        blurredLatitude: Double? = nil,
        blurredLongitude: Double? = nil,
        precisionMeters: Double? = nil,
        recognitionRequestId: String? = nil,
        confirmedCandidateId: String? = nil,
        confidence: Double? = nil
    ) {
        self.id = id
        self.speciesId = speciesId
        self.commonNameZh = commonNameZh
        self.scientificName = scientificName
        self.categoryRawValue = category.rawValue
        self.photoLocalPath = photoLocalPath
        self.thumbnailLocalPath = thumbnailLocalPath
        self.sourceRawValue = source.rawValue
        self.observedAt = observedAt
        self.createdAt = createdAt
        self.locationEnabled = locationEnabled
        self.locationDisplayName = locationDisplayName
        self.blurredLatitude = blurredLatitude
        self.blurredLongitude = blurredLongitude
        self.precisionMeters = precisionMeters
        self.recognitionRequestId = recognitionRequestId
        self.confirmedCandidateId = confirmedCandidateId
        self.confidence = confidence
    }
}

