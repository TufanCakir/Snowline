//
//  AccountView.swift
//  Snowline
//
//  Created by Tufan Cakir on 27.12.25.
//

import SwiftUI

struct AccountView: View {

    @EnvironmentObject var theme: ThemeManager

    private let version =
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        ?? "1.0"
    private let build =
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"

    var body: some View {
        NavigationStack {
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

                Section("About") {
                    NavigationLink("Info") {
                        InfoView()
                    }

                    HStack {
                        Text("Version")
                        Spacer()
                        Text("\(version) (\(build))")
                    }
                }
            }
        }
    }
}

#Preview {
    AccountView()
        .environmentObject(ThemeManager())
        .preferredColorScheme(ThemeManager().colorScheme)
}
