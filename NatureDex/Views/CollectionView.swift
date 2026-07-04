import SwiftData
import SwiftUI

struct CollectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SightingEntity.foundAt, order: .reverse) private var sightings: [SightingEntity]
    @StateObject private var viewModel = CollectionViewModel()

    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Picker("类型", selection: $viewModel.selectedCategory) {
                        Text("全部").tag(SpeciesCategory?.none)
                        ForEach(viewModel.filterCategories) { category in
                            Text(category.displayName).tag(SpeciesCategory?.some(category))
                        }
                    }
                    .pickerStyle(.menu)

                    let filteredSightings = viewModel.filteredSightings(from: sightings)

                    if filteredSightings.isEmpty {
                        ContentUnavailableView(
                            "还没有图鉴记录",
                            systemImage: "square.grid.2x2",
                            description: Text("在拍照页确认一个候选物种后，会保存到这里。")
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.top, 80)
                    } else {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(filteredSightings) { sighting in
                                CollectionCard(sighting: sighting) {
                                    viewModel.delete(sighting, modelContext: modelContext)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("图鉴")
        }
    }
}

private struct CollectionCard: View {
    let sighting: SightingEntity
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: sighting.category.symbolName)
                .font(.system(size: 34))
                .foregroundStyle(.green)
                .frame(maxWidth: .infinity)
                .frame(height: 82)
                .background(Color.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))

            Text(sighting.commonNameZh)
                .font(.headline)
                .lineLimit(1)

            Text(sighting.scientificName)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            HStack {
                Text(sighting.category.displayName)
                Spacer()
                Text(sighting.foundAt, style: .date)
            }
            .font(.caption2)
            .foregroundStyle(.secondary)

            HStack {
                Text("置信度 \(Int(sighting.confidence * 100))%")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Spacer()

                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "trash")
                }
                .buttonStyle(.borderless)
                .accessibilityLabel("删除记录")
            }
        }
        .padding(10)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    CollectionView()
        .modelContainer(for: SightingEntity.self, inMemory: true)
}
