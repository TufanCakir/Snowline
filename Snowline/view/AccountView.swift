//
//  AccountView.swift
//  Khione
//

import StoreKit
import SwiftUI

struct AccountView: View {

    // MARK: - Environment
    @EnvironmentObject private var themeManager: ThemeManager

    // MARK: - Storage
    @AppStorage("khione_username") private var username = ""
    @AppStorage("khione_language")
    private var language =
        Locale.current.language.languageCode?.identifier ?? "en"

    // MARK: - Links
    private let tosURL = URL(string: "https://khione-tos.netlify.app/")!
    private let privacyURL = URL(string: "https://khione-privacy.netlify.app/")!

    // MARK: - Localization
    private var text: AccountLocalization {
        Bundle.main.loadAccountLocalization(language: language)
    }

    // MARK: - Computed
    private var initials: String {
        let letters =
            username
            .split(separator: " ")
            .prefix(2)
            .compactMap(\.first)
        return letters.isEmpty
            ? "?" : letters.map { String($0).uppercased() }.joined()
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            themeManager.backgroundColor.ignoresSafeArea()

            List {
                profileSection
                languageSection
                appSection
                aboutSection
            }
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationTitle(text.title)
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.locale, Locale(identifier: language))
    }
}

extension AccountView {

    fileprivate var profileSection: some View {
        Section {
            VStack(spacing: 14) {

                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 72, height: 72)
                    .overlay(
                        Text(initials)
                            .font(.title.bold())
                            .foregroundColor(.white)
                    )
                    .accessibilityLabel("User avatar")

                TextField(text.profileNamePlaceholder, text: $username)
                    .submitLabel(.done)

                Text(text.profileLocal)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 12)
        }
    }
}

extension AccountView {

    fileprivate var languageSection: some View {
        Section(text.languageSection) {
            Picker(text.languagePicker, selection: $language) {
                Text(text.languageDE).tag("de")
                Text(text.languageEN).tag("en")
            }
            .pickerStyle(.segmented)
            .onChange(of: language) { _, _ in
            }
        }
    }

    fileprivate var appSection: some View {
        Section(text.appSection) {
            NavigationLink {
                AppearanceView()
            } label: {
                Label(text.appearance, systemImage: "moon")
            }
        }
    }

    fileprivate var aboutSection: some View {
        Section(text.aboutSection) {
            NavigationLink {
                KhioneInfoView()
            } label: {
                Label("Khione", systemImage: "snowflake")
            }

            Label(Bundle.main.appVersionString, systemImage: "number")
                .foregroundColor(.secondary)
            Label(text.builtWith, systemImage: "applelogo")

            Link(destination: tosURL) {
                Label(text.tos, systemImage: "doc.text")
            }

            Link(destination: privacyURL) {
                Label(text.privacy, systemImage: "hand.raised")
            }
        }
    }
}

extension View {
    fileprivate func badgeStyle() -> some View {
        self
            .font(.caption.bold())
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color.secondary.opacity(0.15)))
    }

    fileprivate func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
extension Bundle {
    var appVersionString: String {
        let version =
            infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"

        let build =
            infoDictionary?["CFBundleVersion"] as? String ?? ""

        if build.isEmpty {
            return "Version \(version)"
        } else {
            return "Version \(version) (\(build))"
        }
    }
}

#Preview {
    NavigationStack {
        AccountView()
            .environmentObject(ThemeManager())
    }
}
