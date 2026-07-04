import PhotosUI
import SwiftUI
import UIKit

struct CaptureView: View {
    @StateObject private var viewModel = CaptureViewModel()
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var isShowingCamera = false

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
                            isShowingCamera = true
                        } label: {
                            Label("拍照", systemImage: "camera")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(viewModel.isIdentifying || !UIImagePickerController.isSourceTypeAvailable(.camera))

                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            Label("从相册选择", systemImage: "photo")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .disabled(viewModel.isIdentifying)
                    }

                    if let selectedImage = viewModel.selectedImage {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(viewModel.selectedSource == .camera ? "拍摄图片" : "相册图片")
                                .font(.headline)

                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }

                    if viewModel.isIdentifying {
                        VStack(spacing: 12) {
                            ProgressView()
                            Text("识别中...")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    }

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    if !viewModel.candidates.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("候选物种")
                                .font(.headline)

                            ForEach(viewModel.candidates) { candidate in
                                Button {
                                    viewModel.selectCandidate(candidate)
                                } label: {
                                    CandidatePreviewRow(candidate: candidate)
                                }
                                .buttonStyle(.plain)
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
            .navigationDestination(item: $viewModel.selectedCandidate) { candidate in
                SpeciesConfirmView(candidate: candidate)
            }
            .sheet(isPresented: $isShowingCamera) {
                CameraPickerView { image in
                    Task {
                        await viewModel.handlePickedImage(image, source: .camera)
                    }
                }
                .ignoresSafeArea()
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                guard let newItem else {
                    return
                }

                Task {
                    do {
                        if let data = try await newItem.loadTransferable(type: Data.self) {
                            await viewModel.handlePickedImageData(data, source: .photoLibrary)
                        }
                    } catch {
                        viewModel.errorMessage = "无法读取相册图片，请重试。"
                    }

                    selectedPhotoItem = nil
                }
            }
        }
    }
}

private struct CandidatePreviewRow: View {
    let candidate: IdentificationCandidate

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: candidate.category.symbolName)
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

            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(candidate.confidence * 100))%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    CaptureView()
        .modelContainer(for: SightingEntity.self, inMemory: true)
}
