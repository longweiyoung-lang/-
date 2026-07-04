import SwiftUI

struct CollectionView: View {
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
                        ForEach(SpeciesCategory.allCases) { category in
                            Text(category.displayName).tag(SpeciesCategory?.some(category))
                        }
                    }
                    .pickerStyle(.menu)

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.filteredObservations) { observation in
                            CollectionCard(observation: observation)
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
    let observation: MockObservation

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: observation.imageSystemName)
                .font(.system(size: 34))
                .foregroundStyle(.green)
                .frame(maxWidth: .infinity)
                .frame(height: 82)
                .background(Color.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))

            Text(observation.commonNameZh)
                .font(.headline)
                .lineLimit(1)

            Text(observation.scientificName)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            HStack {
                Text(observation.category.displayName)
                Spacer()
                Text(observation.discoveredAt, style: .date)
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        .padding(10)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    CollectionView()
}

