//
//  AddThreadView.swift
//  TinyThoughts
//
//  View for adding a new thread (when pressing the + button in the CollectionDetailView)
//

import SwiftUI

struct AddThreadView: View {
    
    @ObservedObject var viewModel: ThreadViewModel
    @State private var title: String = ""
    @State private var summary: String = ""
    let collection: Collection
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Thread Details")) {
                    TextField("Thread Name", text: $title)
                    TextField("Summary (optional)", text: $summary, axis: .vertical)
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
