import SwiftUI

struct SafetyNoticeView: View {
    var body: some View {
        Label(SafetyCopy.identificationNotice, systemImage: "exclamationmark.triangle")
            .font(.footnote)
            .foregroundStyle(.secondary)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.yellow.opacity(0.16), in: RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    SafetyNoticeView()
        .padding()
}

