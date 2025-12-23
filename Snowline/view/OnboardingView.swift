import SwiftUI

struct OnboardingView: View {

    var onFinish: () -> Void
    @State private var page = 0

    private let lastPage = 2

    var body: some View {
        VStack(spacing: 32) {

            TabView(selection: $page) {

                // ❄️ Seite 1 – eigenes Snowline Icon
                OnboardingPage(
                    icon: {
                        Image("snowline_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                    },
                    title: "Ein klarer Start ins Web",
                    text:
                        "Snowline bietet dir eine minimalistische Suchoberfläche ohne Ablenkungen. "
                        + "Konzentriere dich auf das Wesentliche und starte direkt ins Web."
                )
                .tag(0)

                // 🔒 Seite 2 – Private Mode
                OnboardingPage(
                    icon: {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 44, weight: .semibold))
                            .foregroundStyle(.primary)
                    },
                    title: "Privat surfen, wenn du möchtest",
                    text:
                        "Wechsle jederzeit in den privaten Modus. "
                        + "Besuchte Seiten und Suchanfragen werden dort nicht gespeichert."
                )
                .tag(1)

                // ✨ Seite 3 – Personalisierung
                OnboardingPage(
                    icon: {
                        Image(systemName: "sparkles")
                            .font(.system(size: 44, weight: .semibold))
                            .foregroundStyle(.primary)
                    },
                    title: "Schnell. Einfach. Fokussiert.",
                    text:
                        "Snowline ist auf eine einzige Suchmaschine fokussiert, "
                        + "damit du ohne Umwege direkt ins Web starten kannst."
                )
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .animation(.easeInOut(duration: 0.25), value: page)

            // Action Button
            Button {
                if page < lastPage {
                    page += 1
                } else {
                    onFinish()
                }
            } label: {
                Text(page < lastPage ? "Continue" : "Start using Snowline")
                    .font(.body.weight(.semibold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 24)
    }
}
