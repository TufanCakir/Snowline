//
//  SearchBar.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI

struct SearchBar: View {

    @ObservedObject private var ui = BrowserUI.shared
    @Binding var text: String

    // Optional callbacks to hook search behavior from parent if desired
    var onSubmit: (() -> Void)? = nil
    var onDebouncedChange: ((String) -> Void)? = nil

    @FocusState private var focused: Bool
    @State private var glow = false
    @State private var debounceTask: Task<Void, Never>? = nil

    var body: some View {
        HStack {

            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.secondary)
                .padding()

            TextField("Search the Web", text: $text)
                .focused($focused)
                .submitLabel(.search)
                .font(.system(size: 16, weight: .medium))
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .onSubmit { onSubmit?() }

            if !text.isEmpty {
                Button {
                    withAnimation(.easeOut) { text = "" }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }

            Button {
                // future voice search
            } label: {
                Image(systemName: "mic.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding()
            }
        }
        .padding()
        .background {
            Capsule()
                .fill(.ultraThinMaterial)
        }
        .onTapGesture {
            focused = true
            ui.showAddress = true
        }
        .onChange(of: focused) { _, newValue in
            glow = newValue
        }
        // Use the binding `text` instead of an undefined `query`
        .onChange(of: text) { _, newValue in
            // Simple debounce to avoid firing on every keystroke
            debounceTask?.cancel()
            let value = newValue
            debounceTask = Task { @MainActor in
                try? await Task.sleep(nanoseconds: 180_000_000)  // 180ms
                guard !Task.isCancelled else { return }
                onDebouncedChange?(value)
            }
        }
    }
}

#Preview {
    @Previewable
    @State var previewText = ""
    return SearchBar(text: .constant(previewText))
}
