import SwiftData
import SwiftUI

struct SpeciesConfirmView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var didAdd = false

    let candidate: IdentificationCandidate

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(spacing: 12) {
                    Image(systemName: candidate.category.symbolName)
                        .font(.system(size: 64))
                        .foregroundStyle(.green)
                        .frame(maxWidth: .infinity)
                        .frame(height: 140)
                        .background(Color.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))

                    VStack(alignment: .leading, spacing: 6) {
                        Text(candidate.commonNameZh)
                            .font(.title.bold())
                        Text(candidate.scientificName)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text(candidate.category.displayName)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("识别信息")
                        .font(.headline)
                    Text("置信度 \(Int(candidate.confidence * 100))%")
                    Text(candidate.reason)
                        .foregroundStyle(.secondary)
                }

                SafetyNoticeView()

                if let extraCautionMessage = candidate.extraCautionMessage {
                    Label(extraCautionMessage, systemImage: "exclamationmark.octagon")
                        .font(.footnote)
                        .foregroundStyle(.orange)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.orange.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
                }

                Button {
                    let sighting = SightingEntity(
                        speciesId: candidate.speciesId,
                        commonNameZh: candidate.commonNameZh,
                        scientificName: candidate.scientificName,
                        category: candidate.category,
                        photoURL: candidate.photoURL,
                        localImageName: candidate.localImageName ?? candidate.category.symbolName,
                        foundAt: .now,
                        blurredLatitude: 31.2304,
                        blurredLongitude: 121.4737,
                        locationName: "模糊位置",
                        confidence: candidate.confidence
                    )
                    modelContext.insert(sighting)
                    didAdd = true
                } label: {
                    Label(didAdd ? "已加入图鉴" : "加入图鉴", systemImage: didAdd ? "checkmark.circle" : "plus.circle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(didAdd)
            }
            .padding()
        }
        .navigationTitle("确认物种")
        .toolbar {
            if didAdd {
                ToolbarItem(placement: .automatic) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SpeciesConfirmView(candidate: NatureDexMockData.identificationCandidates[0])
            .modelContainer(for: SightingEntity.self, inMemory: true)
    }
}
