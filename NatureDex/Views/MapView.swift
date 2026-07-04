import MapKit
import SwiftData
import SwiftUI

struct MapView: View {
    @Query(sort: \SightingEntity.foundAt, order: .reverse) private var sightings: [SightingEntity]
    @StateObject private var viewModel = MapViewModel()
    @State private var selectedSighting: SightingEntity?

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.hasLocationPermission {
                    mapContent
                } else {
                    LocationPermissionView(
                        canRequestPermission: viewModel.canRequestPermission,
                        requestPermission: viewModel.requestLocationPermission
                    )
                }
            }
            .navigationTitle("地图")
            .onAppear {
                viewModel.updateCameraIfNeeded(for: sightings)
            }
            .onChange(of: sightings.count) { _, _ in
                viewModel.updateCameraIfNeeded(for: sightings)
            }
            .sheet(item: $selectedSighting) { sighting in
                SightingMapDetailView(sighting: sighting)
            }
        }
    }

    @ViewBuilder
    private var mapContent: some View {
        if sightings.isEmpty {
            ContentUnavailableView(
                "还没有地图足迹",
                systemImage: "map",
                description: Text("确认物种并加入图鉴后，会在这里显示约 500 米范围的模糊发现位置。")
            )
        } else {
            Map(position: $viewModel.position) {
                ForEach(sightings) { sighting in
                    if let coordinate = viewModel.coordinate(for: sighting) {
                        Annotation(sighting.commonNameZh, coordinate: coordinate) {
                            Button {
                                selectedSighting = sighting
                            } label: {
                                Image(systemName: sighting.category.symbolName)
                                    .font(.body)
                                    .foregroundStyle(.white)
                                    .padding(8)
                                    .background(.green, in: Circle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .overlay(alignment: .bottom) {
                Text("发现位置已模糊到约 500 米范围")
                    .font(.footnote)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.thinMaterial, in: Capsule())
                    .padding()
            }
        }
    }
}

private struct LocationPermissionView: View {
    let canRequestPermission: Bool
    let requestPermission: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label("需要定位权限", systemImage: "location.slash")
        } description: {
            Text("地图足迹用于展示你的自然发现区域。App 只展示约 500 米范围的模糊位置，不显示精确坐标。")
        } actions: {
            if canRequestPermission {
                Button("允许定位") {
                    requestPermission()
                }
                .buttonStyle(.borderedProminent)
            } else {
                Text("请在系统设置中允许定位权限后再查看地图足迹。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}

private struct SightingMapDetailView: View {
    let sighting: SightingEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 14) {
                Image(systemName: sighting.category.symbolName)
                    .font(.system(size: 34))
                    .foregroundStyle(.green)
                    .frame(width: 64, height: 64)
                    .background(Color.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 4) {
                    Text(sighting.commonNameZh)
                        .font(.title3.bold())
                    Text(sighting.scientificName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(sighting.foundAt, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Text("位置已模糊显示，不代表精确发现点。")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .presentationDetents([.height(180), .medium])
    }
}

#Preview {
    MapView()
        .modelContainer(for: SightingEntity.self, inMemory: true)
}

