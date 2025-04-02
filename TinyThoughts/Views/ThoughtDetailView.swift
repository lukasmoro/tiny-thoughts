//
//  ThoughtDetailView.swift
//  TinyThoughts
//
//  Created for MVVM refactoring
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
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Created:")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(thought.creationDate ?? Date(), formatter: formatter)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    if let modified = thought.lastModified, modified != thought.creationDate {
                        HStack {
                            Text("Modified:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(modified, formatter: formatter)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal)
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
        .onAppear {
            editedContent = thought.content ?? ""
        }
    }
} 