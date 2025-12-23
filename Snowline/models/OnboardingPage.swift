import SwiftUI

struct OnboardingPage<Icon: View>: View {
    let icon: Icon
    let title: String
    let text: String

    init(
        @ViewBuilder icon: () -> Icon,
        title: String,
        text: String
    ) {
        self.icon = icon()
        self.title = title
        self.text = text
    }

    var body: some View {
        VStack(spacing: 28) {
            Spacer(minLength: 40)

            icon
                .frame(width: 96, height: 96)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.primary.opacity(0.18),
                                    Color.clear,
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )

            VStack(spacing: 12) {
                Text(title)
                    .font(.title2.weight(.semibold))
                    .multilineTextAlignment(.center)

                Text(text)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Spacer()
        }
        .padding(.horizontal)
    }
}
