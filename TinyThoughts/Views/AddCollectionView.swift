//
//  AddCollectionView.swift
//  TinyThoughts
//
//  Created for MVVM refactoring
//

import SwiftUI

struct AddCollectionView: View {
    @ObservedObject var viewModel: CollectionViewModel
    @State private var name: String = ""
    @State private var summary: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Collection Details")) {
                    TextField("Collection Name", text: $name)
                    
                    TextField("Summary (optional)", text: $summary, axis: .vertical)
                        .lineLimit(3...5)
                }
            }
            .navigationTitle("New Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            viewModel.addCollection(
                                name: name,
                                summary: summary.isEmpty ? nil : summary
                            )
                            dismiss()
                        }
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
} 