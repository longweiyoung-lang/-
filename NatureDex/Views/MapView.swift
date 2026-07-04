import MapKit
import SwiftUI

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        NavigationStack {
            Map(position: $viewModel.position) {
                ForEach(viewModel.mappableObservations) { observation in
                    if let coordinate = observation.blurredCoordinate {
                        Annotation(observation.commonNameZh, coordinate: coordinate) {
                            Image(systemName: observation.imageSystemName)
                                .font(.body)
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(.green, in: Circle())
                        }
                    }
                }
            }
            .overlay(alignment: .bottom) {
                Text("位置已默认模糊化，仅展示大致发现区域")
                    .font(.footnote)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.thinMaterial, in: Capsule())
                    .padding()
            }
            .navigationTitle("地图")
        }
    }
}

#Preview {
    MapView()
}

