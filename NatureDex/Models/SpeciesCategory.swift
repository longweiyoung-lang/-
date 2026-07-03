import Foundation

enum SpeciesCategory: String, Codable, CaseIterable, Identifiable {
    case plant
    case insect
    case bird
    case animal
    case other
    case unknown

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .plant:
            "植物"
        case .insect:
            "昆虫"
        case .bird:
            "鸟类"
        case .animal:
            "小动物"
        case .other:
            "其他"
        case .unknown:
            "未知"
        }
    }
}

