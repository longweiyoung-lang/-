import Foundation
import SwiftData

@Model
final class SpeciesEntity {
    @Attribute(.unique) var id: String
    var commonNameZh: String
    var scientificName: String
    var categoryRawValue: String
    var descriptionShort: String?
    var riskHint: String?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: String = UUID().uuidString,
        commonNameZh: String,
        scientificName: String,
        category: SpeciesCategory,
        descriptionShort: String? = nil,
        riskHint: String? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.commonNameZh = commonNameZh
        self.scientificName = scientificName
        self.categoryRawValue = category.rawValue
        self.descriptionShort = descriptionShort
        self.riskHint = riskHint
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

