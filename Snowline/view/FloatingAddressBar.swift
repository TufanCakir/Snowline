//
//  FloatingAddressBar.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI

struct FloatingAddressBar: View {

    @ObservedObject private var ui = BrowserUI.shared
    @Binding var query: String

    @FocusState private var focused: Bool
    @State private var glow = false

    var body: some View {
        ZStack {
            if ui.showAddress {

                // Background dim blur
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture { dismiss() }
                    .transition(.opacity)

                VStack {
                    Spacer()

                    HStack(spacing: 12) {

                        Image(systemName: "lock.fill")
                            .foregroundStyle(.secondary)

                        TextField("Search or enter website", text: $query)
                            .focused($focused)
                            .submitLabel(.search)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .font(.system(size: 16, weight: .medium))

                        if !query.isEmpty {
                            Button {
                                query = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Button("Cancel") { dismiss() }
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background {
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Capsule()
                                    .stroke(glow ? Color.white.opacity(0.35) : .clear, lineWidth: 1.5)
                            )
                    }
                    .shadow(color: .black.opacity(0.35), radius: 18, y: 10)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    .scaleEffect(focused ? 1.03 : 1)
                    .animation(.spring(response: 0.35, dampingFraction: 0.9), value: focused)
                }
                .onAppear {
                    focused = true
                    glow = true
                }
                .onDisappear { glow = false }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeOut(duration: 0.2), value: ui.showAddress)
    }

    private func dismiss() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
            ui.showAddress = false
        }
    }
}
