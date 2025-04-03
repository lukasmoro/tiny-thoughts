//
//  ThoughtDetailView.swift
//  TinyThoughts
//
//  View for displaying and editing a thought
//

import SwiftUI

struct ThoughtDetailView: View {
    @ObservedObject var viewModel: ThoughtViewModel
    let thought: Thought
    let formatter: DateFormatter
    
    @State private var isEditing = false
    @State private var editedContent: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if isEditing {
                    TextField("Edit your thought", text: $editedContent, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .lineLimit(5...20)
                } else {
                    Text(thought.content ?? "")
                        .font(.body)
                        .padding()
                }
            }
        }
        .navigationTitle("Thought Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing {
                    Button("Save") {
                        if !editedContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            viewModel.updateThought(thought, content: editedContent)
                            isEditing = false
                        }
                    }
                } else {
                    Button("Edit") {
                        editedContent = thought.content ?? ""
                        isEditing = true
                    }
                }
            }
        }
        .onChange(of: isEditing) { oldValue, newValue in
            if !newValue {
                viewModel.fetchThoughts()
            }
        }
        .onAppear {
            editedContent = thought.content ?? ""
        }
    }
} 