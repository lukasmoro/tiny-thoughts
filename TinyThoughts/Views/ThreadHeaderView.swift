//
//  ThreadHeaderView.swift
//  TinyThoughts
//
//  Component for displaying and editing a thread header
//

import SwiftUI
import CoreData

struct ThreadHeaderView: View {
    // MARK: - Properties
    let thread: Thread
    let formatter: DateFormatter
    @ObservedObject var threadViewModel: ThreadViewModel
    @Binding var isEditing: Bool
    @Binding var editedTitle: String
    @Binding var editedSummary: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                if isEditing {
                    TextField("Thread Title", text: $editedTitle)
                        .font(.title2)
                        .padding(.bottom, 5)
                } else {
                    Text(thread.title ?? "Untitled Thread")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 5)
                }
                
                Spacer()
                
                if isEditing {
                    Button("Save") {
                        if !editedTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            threadViewModel.updateThread(
                                thread,
                                title: editedTitle,
                                summary: editedSummary.isEmpty ? nil : editedSummary
                            )
                            isEditing = false
                        }
                    }
                    .disabled(editedTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                } else {
                    Button(action: {
                        editedTitle = thread.title ?? ""
                        editedSummary = thread.summary ?? ""
                        isEditing = true
                    }) {
                        Image(systemName: "pencil.circle")
                            .font(.system(size: 25))
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 2)
                }
            }
            
            if isEditing {
                TextField("Summary", text: $editedSummary, axis: .vertical)
                    .lineLimit(3...5)
            } else {
                if let summary = thread.summary, !summary.isEmpty {
                    Text(summary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                if let lastModified = thread.lastModified, lastModified != thread.creationDate {
                    Text("Last modified:")
                        .font(.caption)
                    Text(lastModified, formatter: formatter)
                        .font(.caption)
                } else {
                    Text("Created:")
                        .font(.caption)
                    Text(thread.creationDate ?? Date(), formatter: formatter)
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