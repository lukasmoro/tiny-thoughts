//
//  CollectionHeaderView.swift
//  TinyThoughts
//
//  Component for displaying and editing a collection header
//

import SwiftUI
import CoreData

struct CollectionHeaderView: View {
    
    // MARK: - Properties
    let collection: Collection
    let formatter: DateFormatter
    @ObservedObject var collectionViewModel: CollectionViewModel
    @Binding var editState: CollectionDetailView.EditingState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                if editState.isEditing {
                    TextField("Collection Name", text: $editState.name)
                        .font(.title)
                        .padding(.bottom, 5)
                } else {
                    Text(collection.name ?? "Unnamed Collection")
                        .font(.title)
                        .bold()
                        .padding(.bottom, 5)
                }
                
                Spacer()
                
                if editState.isEditing {
                    Button("Save") {
                        if !editState.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            collectionViewModel.updateCollection(
                                collection,
                                name: editState.name,
                                summary: editState.summary.isEmpty ? nil : editState.summary
                            )
                            editState.isEditing = false
                        }
                    }
                    .disabled(editState.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                } else {
                    Button("Edit") {
                        editState.name = collection.name ?? ""
                        editState.summary = collection.summary ?? ""
                        editState.isEditing = true
                    }
                }
            }
            
            if editState.isEditing {
                TextField("Summary", text: $editState.summary, axis: .vertical)
                    .lineLimit(3...5)
            } else {
                if let summary = collection.summary, !summary.isEmpty {
                    Text(summary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                if let lastModified = collection.lastModified, lastModified != collection.creationDate {
                    Text("Last modified:")
                        .font(.caption)
                    Text(lastModified, formatter: formatter)
                        .font(.caption)
                } else {
                    Text("Created:")
                        .font(.caption)
                    Text(collection.creationDate ?? Date(), formatter: formatter)
                        .font(.caption)
                }
                
                Spacer()
            }
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
    }
} 
