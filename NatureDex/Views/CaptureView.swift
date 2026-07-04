import SwiftUI

struct CaptureView: View {
    @StateObject private var viewModel = CaptureViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 12) {
                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 56))
                            .foregroundStyle(.green)

                        Text("拍摄或选择自然照片")
                            .font(.title2.bold())

                        Text("MVP 阶段使用 mock 识别结果，不会接入真实 API。")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 24)

                    VStack(spacing: 12) {
                        Button {
                            viewModel.simulateCameraCapture()
                        } label: {
                            Label("拍照", systemImage: "camera")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)

                        Button {
                            viewModel.simulatePhotoSelection()
                        } label: {
                            Label("从相册选择", systemImage: "photo")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }

                    if let selectedSource = viewModel.selectedSource {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(selectedSource == .camera ? "模拟拍照结果" : "模拟相册结果")
                                .font(.headline)

                            ForEach(viewModel.mockCandidates) { candidate in
                                CandidatePreviewRow(candidate: candidate)
                            }
                        }
                        .padding()
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    }

                    SafetyNoticeView()
                }
                .padding()
            }
            .navigationTitle("拍照")
        }
    }
}

private struct CandidatePreviewRow: View {
    let candidate: MockObservation

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: candidate.imageSystemName)
                .font(.title2)
                .foregroundStyle(.green)
                .frame(width: 36, height: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(candidate.commonNameZh)
                    .font(.subheadline.bold())
                Text(candidate.scientificName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(Int(candidate.confidence * 100))%")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    CaptureView()
}

