import Foundation

@MainActor
final class CaptureViewModel: ObservableObject {
    @Published var mockCandidates: [MockObservation]
    @Published var selectedSource: ObservationSource?
    @Published var isIdentifying: Bool

    init(
        mockCandidates: [MockObservation] = Array(MockObservation.samples.prefix(2)),
        selectedSource: ObservationSource? = nil,
        isIdentifying: Bool = false
    ) {
        self.mockCandidates = mockCandidates
        self.selectedSource = selectedSource
        self.isIdentifying = isIdentifying
    }

    func simulateCameraCapture() {
        selectedSource = .camera
        isIdentifying = true
        isIdentifying = false
    }

    func simulatePhotoSelection() {
        selectedSource = .photoLibrary
        isIdentifying = true
        isIdentifying = false
    }
}

