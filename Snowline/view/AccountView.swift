//
//  AccountView.swift
//  Snowline
//
//  Created by Tufan Cakir on 27.12.25.
//

import SwiftUI

struct AccountView: View {

    @EnvironmentObject var theme: ThemeManager

    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    private let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"

    var body: some View {
        NavigationStack {
            List {

                Section {
                    HStack {
                        Image(systemName: "globe")
                            .font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text("Snowline")
                                .font(.headline)
                            Text("Version \(version) (\(build))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("Appearance") {
                    Picker("Theme", selection: $theme.current) {
                        Text("System").tag(ThemeManager.Mode.system)
                        Text("Light").tag(ThemeManager.Mode.light)
                        Text("Dark").tag(ThemeManager.Mode.dark)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: theme.current) { oldValue, newValue in
                        theme.apply(newValue)
                    }
                }

                Section("Legal") {
                    Link("Privacy Policy", destination: URL(string: "https://snowline.app/privacy")!)
                    Link("Terms of Use", destination: URL(string: "https://snowline.app/terms")!)
                }

                Section("About") {
                    Text("Snowline is a fast, private and clean web browser built for modern iOS.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Account")
        }
    }
}

#Preview {
    AccountView()
        .environmentObject(ThemeManager())
}

