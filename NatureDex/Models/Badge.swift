import Foundation

struct Badge: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var detail: String
    var iconSystemName: String
    var category: SpeciesCategory?
    var requiredCount: Int
    var currentCount: Int
    var unlockedAt: Date?

    init(
        id: String = UUID().uuidString,
        name: String,
        detail: String,
        iconSystemName: String,
        category: SpeciesCategory? = nil,
        requiredCount: Int,
        currentCount: Int = 0,
        unlockedAt: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.detail = detail
        self.iconSystemName = iconSystemName
        self.category = category
        self.requiredCount = requiredCount
        self.currentCount = currentCount
        self.unlockedAt = unlockedAt
    }
}

