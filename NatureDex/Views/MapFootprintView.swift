import MapKit
import SwiftUI

struct MapFootprintView: View {
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 31.2304, longitude: 121.4737),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    )

    var body: some View {
        NavigationStack {
            Map(position: $position)
                .overlay(alignment: .bottom) {
                    Text("地图足迹默认使用模糊位置")
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
    MapFootprintView()
}

