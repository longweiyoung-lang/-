import Foundation

protocol IdentificationServicing {
    func identifyMockCapture() async throws -> [IdentificationCandidate]
}

struct MockIdentificationService: IdentificationServicing {
    func identifyMockCapture() async throws -> [IdentificationCandidate] {
        try await Task.sleep(for: .seconds(1))
        return Array(NatureDexMockData.identificationCandidates.prefix(3))
    }
}

