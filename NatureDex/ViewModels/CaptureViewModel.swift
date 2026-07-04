import Foundation
import UIKit

@MainActor
final class CaptureViewModel: ObservableObject {
    @Published var candidates: [IdentificationCandidate]
    @Published var selectedSource: ObservationSource?
    @Published var selectedImage: UIImage?
    @Published var isIdentifying: Bool
    @Published var errorMessage: String?
    @Published var selectedCandidate: IdentificationCandidate?

    private let identificationService: IdentificationServicing

    init(
        candidates: [IdentificationCandidate] = [],
        selectedSource: ObservationSource? = nil,
        selectedImage: UIImage? = nil,
        isIdentifying: Bool = false,
        identificationService: IdentificationServicing = MockIdentificationService()
    ) {
        self.candidates = candidates
        self.selectedSource = selectedSource
        self.selectedImage = selectedImage
        self.isIdentifying = isIdentifying
        self.identificationService = identificationService
    }

    func handlePickedImage(_ image: UIImage, source: ObservationSource) async {
        selectedImage = image
        selectedSource = source
        await identifySelectedImage()
    }

    func handlePickedImageData(_ data: Data, source: ObservationSource) async {
        guard let image = UIImage(data: data) else {
            errorMessage = "无法读取这张图片，请换一张试试。"
            return
        }

        await handlePickedImage(image, source: source)
    }

    private func identifySelectedImage() async {
        isIdentifying = true
        errorMessage = nil
        candidates = []
        selectedCandidate = nil

        do {
            candidates = try await identificationService.identifyMockCapture()
        } catch {
            errorMessage = "识别失败，请稍后再试。"
        }

        isIdentifying = false
    }

    func selectCandidate(_ candidate: IdentificationCandidate) {
        selectedCandidate = candidate
    }
}
