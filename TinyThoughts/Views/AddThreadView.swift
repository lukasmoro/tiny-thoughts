//
//  AddThreadView.swift
//  TinyThoughts
//
//  created for tiny software by lukas moro
//
//  add thread view used for adding new threads from the collection detail view through the sheet manager
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
