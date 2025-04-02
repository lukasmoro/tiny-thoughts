//
//  AddThoughtView.swift
//  TinyThoughts
//
//  Created for MVVM refactoring
//

import SwiftUI

struct AddThoughtView: View {
    @ObservedObject var viewModel: ThoughtViewModel
    @State private var thoughtContent: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("What's on your mind?", text: $thoughtContent, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .lineLimit(5...20)
            }
            .navigationTitle("New Thought")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if !thoughtContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            viewModel.addThought(content: thoughtContent)
                            dismiss()
                        }
                    }
                    .disabled(thoughtContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
} 