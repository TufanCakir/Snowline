//
//  InfoView.swift
//  Snowline
//
//  Created by Tufan Cakir on 28.12.25.
//

import SwiftUI

struct InfoView: View {

    private let version =
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        ?? "1.0"
    private let build =
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"

    var body: some View {
        List {

            // App Header
            Section {
                VStack(spacing: 12) {
                    Image(systemName: "snowflake")
                        .font(.system(size: 44))
                        .foregroundStyle(.blue)

                    Text("Snowline")
                        .font(.title2.weight(.semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }

            // About
            Section("About") {
                Text(
                    "Snowline is a clean, fast and privacy-focused web browser built for modern iOS."
                )
                .font(.footnote)
                .foregroundStyle(.secondary)
            }

            // Legal
            Section("Social Media") {
                Link(
                    "YouTube",
                    destination: URL(
                        string:
                            "https://youtube.com/@tufancakirofficial?si=nZYLGS73b-5ePK3J"
                    )!
                )
                Link(
                    "Instagram",
                    destination: URL(
                        string:
                            "https://www.instagram.com/tufan_cakir_?igsh=MXg1dnUwajFrZTJmdA%3D%3D&utm_source=qr"
                    )!
                )
                Link(
                    "X",
                    destination: URL(string: "https://x.com/Tufan_Cakir_")!
                )
                Link(
                    "TikTok",
                    destination: URL(
                        string: "https://www.tiktok.com/@tufancakirofficial"
                    )!
                )
                Link(
                    "Linkedin",
                    destination: URL(
                        string:
                            "https://www.linkedin.com/in/tufan-cakir-b03842358/"
                    )!
                )
            }

            HStack {
                Text("Version")
                Spacer()
                Text("\(version) (\(build))")
            }
        }
    }
}

#Preview {
    NavigationStack {
        InfoView()
            .environmentObject(ThemeManager())
            .preferredColorScheme(ThemeManager().colorScheme)
    }
}
