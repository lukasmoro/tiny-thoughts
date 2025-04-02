//
//  AddThreadView.swift
//  TinyThoughts
//
//  Created for MVVM refactoring
//

import SwiftUI

struct AddThreadView: View {
    @ObservedObject var viewModel: ThreadViewModel
    let collection: Collection
    
    @State private var title: String = ""
    @State private var summary: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Thread Details")) {
                    TextField("Thread Title", text: $title)
                    
                    TextField("Summary (optional)", text: $summary, axis: .vertical)
                        .lineLimit(3...5)
                }
                
                Section {
                    Text("This thread will be added to: \(collection.name ?? "Unnamed Collection")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("New Thread")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            viewModel.addThread(
                                title: title,
                                summary: summary.isEmpty ? nil : summary,
                                in: collection
                            )
                            dismiss()
                        }
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
} 