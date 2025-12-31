//
//  InfoView.swift
//  Snowline
//
//  Created by Tufan Cakir on 28.12.25.
//

import SwiftUI

struct InfoView: View {

    // MARK: - Storage
    @AppStorage("khione_language") private var language =
        Locale.current.language.languageCode?.identifier ?? "en"

    // MARK: - Content
    private var content: InfoContent {
        Bundle.main.loadKhioneInfo(language: language)
    }

    private let version = AppInfo.version
    private let build = AppInfo.build

    var body: some View {
        List {
            headerSection
            dynamicSections  // ← enthält jetzt auch About Slayken
            socialSection
            versionSection
        }
        .navigationTitle(content.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerSection: some View {
        Section {
            VStack(spacing: 12) {
                Image(systemName: "snowflake")
                    .font(.system(size: 44))
                    .foregroundStyle(.cyan)

                Text(content.title)
                    .font(.title.bold())

                Text(content.subtitle)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }

    private var dynamicSections: some View {
        ForEach(content.sections) { section in
            Section(section.title) {
                Text(section.text)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var socialSection: some View {
        Section("Social") {
            socialRow(
                "YouTube",
                "play.rectangle",
                "https://youtube.com/@tufancakirofficial?si=nZYLGS73b-5ePK3J"
            )
            socialRow(
                "Instagram",
                "camera",
                "https://www.instagram.com/tufan_cakir_?igsh=MXg1dnUwajFrZTJmdA%3D%3D&utm_source=qr"
            )
            socialRow("X", "xmark", "https://x.com/Tufan_Cakir_")
            socialRow(
                "TikTok",
                "music.note",
                "https://www.tiktok.com/@tufancakirofficial"
            )
            socialRow(
                "LinkedIn",
                "link",
                "https://www.linkedin.com/in/tufan-cakir-b03842358/"
            )
        }
    }

    private func socialRow(_ title: String, _ icon: String, _ url: String)
        -> some View
    {
        Link(destination: URL(string: url)!) {
            Label(title, systemImage: icon)
        }
    }

    private var versionSection: some View {
        Section {
            LabeledContent("Version", value: "\(version) (\(build))")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        InfoView()
            .environmentObject(ThemeManager())
    }
}
