//
//  TabsOverlay.swift
//  Snowline
//
//  Created by Tufan Cakir on 27.12.25.
//

import SwiftUI

struct TabsOverlay: View {

    @EnvironmentObject var session: TabSession
    @Binding var showing: Bool

    @State private var appear = false

    let cols = [GridItem(.adaptive(minimum: 160), spacing: 18)]

    var body: some View {
        ZStack {

            // Real Safari Blur Backdrop
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
                .opacity(appear ? 1 : 0)
                .onTapGesture { close() }

            ScrollView {
                LazyVGrid(columns: cols, spacing: 18) {

                    ForEach(session.tabs) { tab in
                        VStack(spacing: 8) {

                            ZStack(alignment: .topTrailing) {

                                tabPreview(tab)
                                    .overlay(activeBorder(tab))
                                    .shadow(
                                        color: .black.opacity(0.15),
                                        radius: 10,
                                        y: 6
                                    )

                                // Close Button
                                Button {
                                    withAnimation { session.close(tab) }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title3)
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(8)
                            }
                            .onTapGesture {
                                session.select(tab)  // statt session.selectedTabID = ...
                                NotificationCenter.default.post(
                                    name: .tabDidSelect,
                                    object: nil
                                )
                                showing = false
                            }

                            Text(
                                tab.engine.currentURLString.isEmpty
                                    ? "New Tab" : tab.engine.currentURLString
                            )
                            .font(.caption2)
                            .lineLimit(1)
                            .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 22)
                .padding(.top, 50)
                .padding(.bottom, 30)
            }
            .opacity(appear ? 1 : 0)
            .scaleEffect(appear ? 1 : 0.95)
        }
        .animation(
            .spring(response: 0.38, dampingFraction: 0.85),
            value: appear
        )
        .onAppear { appear = true }
    }

    // MARK: - Preview Card
    @ViewBuilder
    private func tabPreview(_ tab: BrowserTab) -> some View {
        if let img = tab.snapshot {
            Image(uiImage: img)
                .resizable()
                .scaledToFill()
                .frame(height: 230)
                .clipShape(RoundedRectangle(cornerRadius: 22))
        } else {
            RoundedRectangle(cornerRadius: 22)
                .fill(.secondary.opacity(0.18))
                .frame(height: 230)
        }
    }

    // MARK: - Active Tab Border
    private func activeBorder(_ tab: BrowserTab) -> some View {
        RoundedRectangle(cornerRadius: 22)
            .stroke(
                session.selectedTabID == tab.id ? Color.accentColor : .clear,
                lineWidth: 3
            )
    }

    // MARK: - Close Overlay
    private func close() {
        appear = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
            showing = false
        }
    }
}
extension Notification.Name {
    static let tabDidSelect = Notification.Name("tabDidSelect")
}
